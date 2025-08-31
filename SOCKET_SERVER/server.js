const http = require("http");
const express = require("express");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);

  const token = socket.handshake.query.token;
  console.log("Token from client:", token);

  if (token !== "123") {
    console.log("Invalid token, disconnecting");
    socket.disconnect(true);
    return;
  }

  socket.on("room:status", (roomId) => {
    console.log("Room status changed:", roomId);
    io.emit("room:status:changed", roomId);
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

server.listen(3001, () => {
  console.log("Socket server listening on port 3001");
});