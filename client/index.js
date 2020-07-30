const express = require("express");
const app = express();
const port = 8000;
const publicWebFolder = __dirname + "/web";

app.use("/", express.static(publicWebFolder));
app.get("/*", (request, response) => {
    response.status(404).sendFile(`${publicWebFolder}/404.html`);
});

app.listen(port, () => console.log(`ETS listening with port ${port}`));
