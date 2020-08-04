let uploadForm = document.querySelector("#uploadForm");
let inputFile = document.querySelector("#inputFile");
let ascii = document.querySelector("#ascii");
let fileName = document.querySelector("#fileName");
let imagePreview = document.querySelector("#imagePreview");


inputFile.addEventListener("change", (e) => {
    fileName.innerHTML = `${inputFile.files[0].name}`;
});

uploadForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    var size = 100;
    const endpoint =
        "http://dynamic.felixyeung2002.com/api/ascii/?size=50&size=50";
    // `http://192.168.1.3:8081/api/ascii/?size=${size}&size=${size}`;
    const formData = new FormData();

    formData.append("image", inputFile.files[0]);
    let file = inputFile.files[0];
    if (file) {
        const reader = new FileReader();

        reader.addEventListener('load', () => {
            imagePreview.src= (`${reader.result}`)
        }, false)
    
        reader.readAsDataURL(file);
    }


    ascii.innerHTML = "Loading...";

    scrollTo({
        top: document.body.clientHeight,
        behavior: "smooth",
    });

    let response = await fetch(endpoint, {
        method: "post",
        body: formData,
    });

    let json = await response.json();

    // console.log(json)

    if (json && json["message"]) {
        ascii.innerHTML = json["message"];
        imagePreview.width = ascii.clientWidth;
        imagePreview.height = ascii.clientHeight;
    }
});
