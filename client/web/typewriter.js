const typewriter = async ({
    element = document.createElement("div"),
    strings = [],
    prefix = "",
    between = ' ',
}) => {
    // https://www.includehelp.com/code-snippets/javascript-to-detect-whether-page-is-load-on-mobile-or-desktop.aspx
    var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
    if (!element) throw "[typewriter.js] No element found";
    if (!strings || strings.length <= 0)
        throw "[typewriter.js] No strings found";
    if (isMobile) {
        return;
    }

    let messageElement = document.createElement("span");
    messageElement.classList.add("message");
    element.append(messageElement);
    let cursorElement = document.createElement("span");
    cursorElement.classList.add("cursor");
    cursorElement.textContent = "|";
    element.append(cursorElement);

    const path = window.location.origin + window.location.pathname;

    function sleep(ms) {
        return new Promise((resolve) => setTimeout(resolve, ms));
    }

    function setMessage(message) {
        messageElement.innerHTML = prefix;

        let span = document.createElement("span");
        span.textContent = message;

        messageElement.append(span);
    }

    var message = "";
    while (true) {
        for (var str of strings) {
            str = between + str;
            for (const char of [...str]) {
                await sleep(100 + Math.random() * 200);
                message += char;
                setMessage(message);
            }
            await sleep(1500);
            for (const char of [...message]) {
                await sleep(25);
                message = message.slice(0, -1);
                setMessage(message);
            }
            await sleep(500);
        }
    }
};
