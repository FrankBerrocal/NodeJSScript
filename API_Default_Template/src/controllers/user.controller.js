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
