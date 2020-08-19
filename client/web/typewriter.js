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
            cursorElement.classList.remove('blinking')
            for (const char of [...str]) {
                await sleep(50 + Math.random() * 100);
                message += char;
                setMessage(message);
            }
            cursorElement.classList.add('blinking')
            await sleep(3000);
            cursorElement.classList.remove('blinking')
            for (const char of [...message]) {
                await sleep(25);
                message = message.slice(0, -1);
                setMessage(message);
            }
            cursorElement.classList.add('blinking')
            await sleep(1000);
        }
    }
};
