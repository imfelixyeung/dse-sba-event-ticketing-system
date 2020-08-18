(async (typewriterStrings = []) => {
    // https://www.includehelp.com/code-snippets/javascript-to-detect-whether-page-is-load-on-mobile-or-desktop.aspx
    var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
    if (isMobile) {
        return;
    }

    const path = window.location.origin + window.location.pathname;

    function sleep(ms) {
        return new Promise((resolve) => setTimeout(resolve, ms));
    }

    function setMessage(message) {
        history.replaceState({}, "", `${path}?${message}`);
    }

    var message = "";
    while (true) {
        for (var str of typewriterStrings) {
            str = str.split(" ").join("_");
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
        }
    }
})([
    "Event Ticketing System",
    "Tickets Made Easy",
    "Beautiful UI",
    "Excellent UX",
    "Site Under Construction",
]);
