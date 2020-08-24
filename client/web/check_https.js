(async () => {
    var isHTTPS = window.location.protocol.includes("https");
    
    console.log({
        isHTTPS,
    });
    
    if (isHTTPS) return;

    var httpsUrl = window.location.href.replace('http', 'https');

    if (httpsUrl.includes(':8000')) httpsUrl = httpsUrl.replace(':8000', ':8443');


    console.log({httpsUrl})

    var httpsAvailable;

    try {
        await fetch(httpsUrl);
        httpsAvailable = true;
    } catch (error) {
        httpsAvailable = false;
    }

    if (httpsAvailable) {
        window.location.href = httpsUrl;
    }
    
})();
