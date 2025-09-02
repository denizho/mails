const express = require('express');
const nodemailer = require('nodemailer');
const knex = require('knex')(require('./knexfile'));
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = 4040;

app.use(cors());
app.use(bodyParser.json());
app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

let emailQueue = [];
let isSending = false;

const createTransporter = (from_email, sender_key) => nodemailer.createTransport({
    service: 'gmail',
    host: "smtp.gmail.com",
    port: 587,
    secure: false,
    auth: { user: from_email, pass: sender_key },
});

const sendMail = (sender, mOptions) => new Promise((resolve, reject) => {
    const timeout = setTimeout(() => reject(new Error('ошибка')), 10000);
    sender.sendMail(mOptions, (e, info) => {
        clearTimeout(timeout);
        e ? reject(e) : resolve(info);
    });
});

const logEmail = async (from_email, sender_key, to_email, subject, message, attachments, status, old_email = null, new_email = null, delivered_at = null) => {
    await knex('logs').insert({
        from_email, sender_key, to_email, subject, message,
        attachments: JSON.stringify(attachments), status, old_email, new_email,
        updated_at: new Date(), delivered_at
    });
};

const processQueue = async () => {
    if (isSending || emailQueue.length === 0) return;

    isSending = true;

    while (emailQueue.length > 0) {
        const { email, subject, text, from_email, sender_key, attachments } = emailQueue.shift();
        const sender = createTransporter(from_email, sender_key);
        const mOptions = { from: from_email, to: email, subject, text, attachments };

        try {
            await sendMail(sender, mOptions);
            await logEmail(from_email, sender_key, email, subject, text, attachments, 'отправлено', null, null, new Date());
            console.log(`отправлено: ${email}`);
        } catch {
            await logEmail(from_email, sender_key, email, subject, text, attachments, 'ошибка');
        }

        await new Promise(resolve => setTimeout(resolve, 60000));
    }

    isSending = false;
};

app.get('/', async (req, res) => {
    try {
        const emails = await knex('emails').orderBy('created_at', 'desc');
        const queuedEmails = emailQueue.map(email => ({
            email: email.email,
            subject: email.subject,
            status: 'Ожидание',
            from_email: email.from_email,
            sender_key: email.sender_key,
            text: email.text,
            attachments: email.attachments,
        }));
        res.render('index', { emails, queuedEmails });
    } catch {
        res.sendStatus(500);
    }
});

app.post('/send-email', async (req, res) => {
    const { email, subject, text, from_email, sender_key, attachments } = req.body;

    if (!text) return res.status(400).send('Текст обязателен');

    emailQueue.push({ email, subject, text, from_email, sender_key, attachments });

    if (!isSending) processQueue();

    await knex('emails').insert({
        email, subject, text, from_email, sender_key,
        attachments: JSON.stringify(attachments), status: 'отправлено',
    });

    await logEmail(from_email, sender_key, email, subject, text, attachments, 'отправлено');

    res.sendStatus(200);
});

app.post('/send-email-now', async (req, res) => {
    const { email, subject, text, from_email, sender_key, attachments } = req.body;

    if (!text) return res.status(400).send('Текст обязателен');

    const sender = createTransporter(from_email, sender_key);
    const mOptions = { from: from_email, to: email, subject, text, attachments };

    try {
        await sendMail(sender, mOptions);
        emailQueue = emailQueue.filter(item => item.email !== email || item.subject !== subject || item.text !== text);
        await logEmail(from_email, sender_key, email, subject, text, attachments, 'отправлено', null, null, new Date());
        res.sendStatus(200);
    } catch {
        await logEmail(from_email, sender_key, email, subject, text, attachments, 'ошибка');
        res.status(500).send('Ошибка отправки');
    }
});

app.post('/edit-email', async (req, res) => {
    const {oldEmail, newEmail, subject } = req.body;

    const emailItem = emailQueue.find(item => item.email === oldEmail && item.subject === subject);
    if (!emailItem) return res.status(404).send('Email не найден в очереди');

    emailItem.email = newEmail;

    const updatedRows = await knex('emails').where({ email: oldEmail, subject }).update({ email: newEmail });
    if (updatedRows === 0) return res.status(404).send('Email не найден в базе данных');

    await logEmail(emailItem.from_email, emailItem.sender_key, newEmail, subject, emailItem.text, emailItem.attachments, 'отредактировано', oldEmail);

    res.sendStatus(200);
});

app.delete('/delete-email', async (req, res) => {
    const { email, subject } = req.body;

    emailQueue = emailQueue.filter(item => item.email !== email || item.subject !== subject);

    await knex('emails').where({ email, subject }).del();

    await logEmail(null, null, email, subject, null, null, 'удалено');

    res.sendStatus(200);
});

app.listen(PORT, () => {
    console.log(`${PORT}`);
});