const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");
const app = express();
var morgan = require("morgan");
const http = require("http");
// const https = require("https");
const cors = require("cors");

const httpPort = 8005;
// const httpsPort = 8443;
const publicWebFolder = __dirname + "/web";
const reportFolder = __dirname + "/../report";
const fs = require("fs");

var options = {
    key: fs.readFileSync("ssl/ets-key.pem"),
    cert: fs.readFileSync("ssl/ets-cert.pem"),
};

app.use(cors());
app.use(morgan("dev"));

app.use(
    "/api/chatBot",
    createProxyMiddleware({
        target: "http://localhost:8082",
        pathRewrite: (path, req) => {
            return path;
        },
    })
);

app.use(
    "/api",
    createProxyMiddleware({
        target: "http://localhost:8081",
        pathRewrite: (path, req) => {
            return path;
        },
    })
);

app.use("/", express.static(publicWebFolder));
app.use("/report", express.static(reportFolder));

app.get("/*", (request, response) => {
    response.status(404).sendFile(`${publicWebFolder}/404.html`);
});

http.createServer(app).listen(httpPort, () =>
    console.log(`HTTP ETS listening with port ${httpPort}`)
);

// https
//     .createServer(options, app)
//     .listen(httpsPort, () =>
//         console.log(`HTTPS ETS listening with port ${httpsPort}`)
//     );

// app.listen(httpPort, () => console.log(`ETS listening with port ${httpPort}`));
