const users_data = require("../data/users.data");
// get out of folder using ../, then go to data folder and get users.data.js file
//get all users
const getAllUsers = (req, res) => {
  res.status(200).json(users_data);
};
//get all users by id
const getUserById = (req, res) => {
  const userId = parseInt(req.params.id);
  //verification of parameter id, if it is not a number, return an error
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
// This function sends the users data as a JSON response
module.exports = {
  getAllUsers,
  getUserById,
};
