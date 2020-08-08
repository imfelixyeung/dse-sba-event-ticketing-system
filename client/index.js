const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");
const app = express();
const port = 8000;
var morgan = require('morgan');
const publicWebFolder = __dirname + "/web";

app.use(morgan('dev'));

app.use(
    "/api",
    createProxyMiddleware({
        target: "http://localhost:8081",
        pathRewrite: (path, req) => {
            console.log(path);
            return path;
        },
    })
);

app.use("/", express.static(publicWebFolder));

app.get("/*", (request, response) => {
    response.status(404).sendFile(`${publicWebFolder}/404.html`);
});


app.listen(port, () => console.log(`ETS listening with port ${port}`));
