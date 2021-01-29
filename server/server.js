const { request } = require("express");
const express = require("express");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const mongoURI = require("./secrets");
const User = require("./models/user");
const app = express();

async function createDB() {
  await mongoose.connect(mongoURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  console.log("Db connected");
}
app.use(express.json({ extended: false }));
createDB();
app.get("/", (req, res) => {
  res.send("Hello Flutter");
});

app.post("/signup", async (req, res) => {
  const { email, password } = req.body;
  try {
    let existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(404)
        .json({ message: "A user with this email already exists" });
    }
    let user = new User({
      email,
      password,
    });
    await user.save();
    const token = jwt.sign({ id: user._id }, "secretpassword");
    res.status(200).json({ token: token.toString() });
  } catch (error) {
    res.status(500).json({ message: "Server Error" });
  }
});
app.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    var user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "No user with this email" });
    }
    if (user.password != password) {
      return res.status(403).json({ message: "Wrong Password" });
    }
    const token = jwt.sign({ id: user._id }, "secretpassword");
    res.status(200).json(token);
  } catch (error) {
    res.status(500).json({ message: "Server Error" });
  }
});

app.listen(3000, () => console.log("Server running on http://localhost:3000"));
