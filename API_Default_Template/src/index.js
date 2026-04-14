const express = require('express');
const dotenv = require('dotenv');
const userRoutes = require('./routes/user.routes');
dotenv.config();
const app = express();
const morgan = require('morgan');
app.use(morgan('dev'));
const PORT = process.env.PORT || 4001;
app.use(express.json());
app.get('/', (req, res) => {
  res.json({ ok: true, message: 'Servidor funcionando' });
});
app.use("/api/v1/users", userRoutes);
app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
