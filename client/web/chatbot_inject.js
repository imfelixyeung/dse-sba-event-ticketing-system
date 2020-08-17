(async ({
    headerMessage,
    inputPlaceholder,
    sendButtonLabel,
    errorMessage,
    hideBoxMessage,
    showBoxMessage,
}) => {
    headerMessage = headerMessage || "How can we help?";
    inputPlaceholder = inputPlaceholder || "Message...";
    sendButtonLabel = sendButtonLabel || "Send";
    errorMessage = errorMessage || "Unable to connect to server";

    const endpoint = "/api/chatBot";
    var id = Math.random().toString();
    // const endpoint = 'http://dynamic.felixyeung2002.com/api/chatBot';
    var chatbot = {};
    let box = document.createElement("div");
    box.classList.add("chatbot-box");

    var header = document.createElement("header");
    header.classList.add("chatbot-header");
    header.textContent = headerMessage;

    var historyContainer = document.createElement("div");
    historyContainer.classList.add("chatbot-history");

    var input = document.createElement("input");
    input.placeholder = inputPlaceholder;
    input.classList.add("chatbot-box-input");
    input.type = "text";
    var submit = document.createElement("button");
    submit.classList.add("chatbot-box-button");
    submit.textContent = sendButtonLabel;

    var inputGrid = document.createElement("div");
    inputGrid.classList.add("chatbot-box-controls");
    inputGrid.append(input, submit);

    box.append(header);
    box.append(historyContainer);
    box.append(inputGrid);

    input.addEventListener("keyup", function (event) {
        if (event.keyCode === 13) {
            event.preventDefault();
            submit.click();
        }
    });

    submit.addEventListener("click", async () => {
        var message = input.value;
        if (message.trim() == "") return;
        input.disabled = true;
        submit.disabled = true;
        input.value = "";
        historyContainer.append(createUserMessage(message));
        saveChatHistory({
            type: "user",
            message,
        });
        // historyContainer.scrollTop = historyContainer.scrollHeight;
        scrollToBottom(historyContainer);

        var responses = await getResponses(message);
        if (responses.length <= 0) {
            historyContainer.append(createSystemMessage(errorMessage));
            saveChatHistory({
                type: "system",
                message: errorMessage,
            });
        } else {
            responses.forEach((response) => {
                historyContainer.append(createBotMessage(response));
                saveChatHistory({
                    type: "bot",
                    message: response,
                });
            });
        }

        input.disabled = false;
        submit.disabled = false;
        input.focus();
        // historyContainer.scrollTop = historyContainer.scrollHeight;
        scrollToBottom(historyContainer);
    });

    function createMessage(message) {
        let messageDiv = document.createElement("div");
        messageDiv.classList.add("chatbot-message");
        messageDiv.textContent = message;
        return messageDiv;
    }

    function createSystemMessage(message) {
        let messageDiv = createMessage(message);
        messageDiv.classList.add("chatbot-message-system");
        return messageDiv;
    }

    function createUserMessage(message) {
        let messageDiv = createMessage(message);
        messageDiv.classList.add("chatbot-message-user");
        return messageDiv;
    }

    function createBotMessage(message) {
        let messageDiv = createMessage(message);
        messageDiv.classList.add("chatbot-message-bot");
        return messageDiv;
    }

    async function getResponses(message) {
        try {
            var response = await fetch(
                `${endpoint}?message=${message}&id=${id}`
            );
            var json = await response.json();
            return json.response;
        } catch (error) {
            return [];
        }
    }

    const chatBotHistory = "chatBotHistory";

    function saveChatHistory({ type, message }) {
        let historyMessages = JSON.parse(
            window.sessionStorage.getItem(chatBotHistory) || "[]"
        );
        historyMessages.push({ type, message });
        window.sessionStorage.setItem(
            chatBotHistory,
            JSON.stringify(historyMessages)
        );
    }

    function loadChatHistory() {
        let historyMessages = JSON.parse(
            window.sessionStorage.getItem(chatBotHistory) || "[]"
        );
        for (const historyMessage of historyMessages) {
            const { type, message } = historyMessage;
            switch (type) {
                case "bot":
                    historyContainer.append(createBotMessage(message));
                    break;
                case "user":
                    historyContainer.append(createUserMessage(message));
                    break;
                case "system":
                    historyContainer.append(createSystemMessage(message));
                    break;

                default:
                    break;
            }
        }
        setTimeout(e => scrollToBottom(historyContainer, false));
        
    }

    function scrollToBottom(element, smooth = true) {
        element.scrollTo({
                 top: element.scrollHeight,
                 behavior: smooth ? "smooth" : undefined,
             });
    }

    loadChatHistory();

    document.body.append(box);

    chatbot.open = window.localStorage.getItem("chatbot-box-open") || "false";
    chatbot.open = JSON.parse(chatbot.open);
    chatbot.box = box;

    var toggle = document.createElement("div");
    toggle.classList.add("chatbot-toggle");

    toggle.addEventListener("click", () => {
        chatbot.open = !chatbot.open;
        window.localStorage.setItem("chatbot-box-open", chatbot.open);
        handleToggle();
    });

    function handleToggle() {
        if (chatbot.open) {
            toggle.textContent = hideBoxMessage;
            toggle.classList.remove("hide");
            box.classList.remove("hide");
        } else {
            toggle.textContent = showBoxMessage;
            toggle.classList.add("hide");
            box.classList.add("hide");
        }
    }

    handleToggle();

    document.body.append(toggle);

    chatbot.toggle = toggle;
})({
    headerMessage: "How can we help?",
    inputPlaceholder: "Message...",
    sendButtonLabel: "Send",
    errorMessage: "An Error Occurred",
    hideBoxMessage: "Hide",
    showBoxMessage: "Help",
});
