#!/bin/bash

# Create directory and enter it
mkdir -p API_Default_Template && cd API_Default_Template

# Server environment
npm init -y && \

# Module installation
npm install express morgan cors dotenv && \

# Server reinitialization (Dev dependency)
npm install -D nodemon && \

# Folder structure
mkdir -p src/routes src/controllers src/services src/repositories src/data src/config && \

# Files
touch src/index.js \
      src/routes/user.routes.js \
      src/controllers/user.controller.js \
      src/services/user.service.js \
      src/repositories/user.repository.js \
      src/data/users.data.js \
      src/config/env.js \
      .env \
      .gitignore && \

# Gitignore instructions
cat > .gitignore << 'EOF'
node_modules
.env
dist
coverage
*.log
EOF

# Env instructions
cat > .env << 'EOF'
PORT=4001
NODE_ENV=development
API_KEY=tu_clave_secreta
EOF

# Package json setup 
npm pkg set scripts.dev="nodemon src/index.js"
npm pkg set author="Frank Berrocal"

# Data setup
cat > src/data/users.data.js << 'EOF'
let users = [
{ "id": 1, "username": "jkarls", "email": "jason.karls@example.com", "role": "admin", "status": "active", "_comment": "System administrator" },
{ "id": 2, "username": "karl_smith", "email": "karl.s@example.com", "role": "editor", "status": "active", "_comment": "Content manager" },
{ "id": 3, "username": "alice_data", "email": "alice.analytics@example.com", "role": "viewer", "status": "inactive", "_comment": "Data science intern" },
{ "id": 4, "username": "bob_jones", "email": "bob.jones@example.com", "role": "developer", "status": "active", "_comment": "Backend developer" },
{ "id": 5, "username": "charlie_brown", "email": "charlie.brown@example.com", "role": "viewer", "status": "active", "_comment": "Frontend developer" }
];
module.exports = users;
EOF

# Index setup
cat > src/index.js << 'EOF'
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
EOF

# Controller setup
cat > src/controllers/user.controller.js << 'EOF'
const users_data = require("../data/users.data");
const getAllUsers = (req, res) => {
  res.status(200).json(users_data);
};
const getUserById = (req, res) => {
  const userId = parseInt(req.params.id);
  if (isNaN(userId)) {
    return res.status(400).json({ message: "Invalid user ID" }); 
  }
const user = users_data.find((u) => u.id === userId);
  if (user) {
    res.status(200).json(user);
  } else {
    res.status(404).json({ message: "User not found" });
  }
};
const createUser = (req, res) => {
  const { username, email, role, status, _comment } = req.body;
  if (!username || username.trim() === "" || !email || email.trim() === "" || !role || role.trim() === "" || !status || status.trim() === "") {
    return res.status(400).json({ message: "Name, email, role, and status are required" });
  }
  const newUser = {
    id: users_data.length > 0 ? users_data[users_data.length - 1].id + 1 : 1,
    username: username.trim(),
    email: email.trim(),
    role: role.trim(),
    status: status.trim(),
    _comment: _comment ? _comment.trim() : "",
  };
  users_data.push(newUser);
  res.status(201).json(newUser);
};
const updateUser = (req, res) => {
  const userId = parseInt(req.params.id);
   const { username, email, role, status, _comment } = req.body;
   if (isNaN(userId)) {
    return res.status(400).json({ message: "Invalid user ID" });
  }
  const userIndex = users_data.findIndex((u) => u.id === userId);
  if (userIndex === -1) {
    return res.status(404).json({ message: "User not found" });
  }
  if (!username && !email && !role && !status && !_comment) {
    return res.status(400).json({ message: "At least one field is required" });
  }
  const updatedUser = { ...users_data[userIndex] };
  if (username) updatedUser.username = username.trim();
  if (email) updatedUser.email = email.trim();
  if (role) updatedUser.role = role.trim();
  if (status) updatedUser.status = status.trim();
  if (_comment) updatedUser._comment = _comment.trim();
  users_data[userIndex] = updatedUser;
  res.status(200).json(updatedUser);
};
const deleteUser = (req, res) => {
  const userId = parseInt(req.params.id);
  if (isNaN(userId)) {
    return res.status(400).json({ message: "Invalid user ID" });
  }
  const userIndex = users_data.findIndex((u) => u.id === userId);
  if (userIndex === -1) {
    return res.status(404).json({ message: "User not found" });
  }
  users_data.splice(userIndex, 1);
  res.status(204).send();
};
module.exports = { getAllUsers, getUserById, createUser, updateUser, deleteUser };
EOF

# Router setup 
cat > src/routes/user.routes.js << 'EOF'
const express = require("express");
const router = express.Router();
const { getAllUsers, getUserById, createUser, updateUser, deleteUser  } = require("../controllers/user.controller");
router.get("/", getAllUsers);
router.get("/:id", getUserById);
router.post("/", createUser);
router.put("/:id", updateUser);
router.delete("/:id", deleteUser);
module.exports = router;
EOF

# Run the project
npm run dev


#Instructions
#nano setup_api.sh
#run this command to give the file permission to execute:
#chmod +x setup_api.sh
#execute the file:
#./setup_api.sh
