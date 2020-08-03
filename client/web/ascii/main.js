let uploadForm = document.querySelector("#uploadForm");
let inputFile = document.querySelector("#inputFile");
let ascii = document.querySelector("#ascii");
let fileName = document.querySelector("#fileName");

inputFile.addEventListener("change", (e) => {
    fileName.innerHTML = `${inputFile.files[0].name}`;
});

uploadForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    // var size = 100;
    const endpoint =
        "http://dynamic.felixyeung2002.com:8081/api/ascii/?size=50&size=50";
        // `http://192.168.1.3:8081/api/ascii/?size=${size}&size=${size}`;
    const formData = new FormData();

    formData.append("image", inputFile.files[0]);

    let response = await fetch(endpoint, {
        method: "post",
        body: formData,
    });

    let json = await response.json();

    // console.log(json)

    if (json && json["message"]) {
        ascii.innerHTML = json["message"];
    }

    scrollTo({
        top: document.body.clientHeight,
        behavior: "smooth",
    });
});
