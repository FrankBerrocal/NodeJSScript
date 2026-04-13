const express = require('express');
const dotenv = require('dotenv');
const userRoutes = require('./routes/user.routes');
dotenv.config();
const app = express();
const PORT = process.env.PORT || 4001;
app.use(express.json());
//status message for root route on browser
app.get('/', (req, res) => {
  res.json({ ok: true, message: 'Servidor funcionando' });
});
//status message for console when server is running
app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
//get all users route
app.use("/api/v1/users", userRoutes);
