//import from packages

const express = require("express");
const mongoose = require("mongoose");

//import from other files

const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
//INIT

const PORT = 3000;
const app = express();
const DB =
  "mongodb+srv://hoaiangonzalo:Jackismyname%21%4012@cluster0.sv40smw.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

//middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
