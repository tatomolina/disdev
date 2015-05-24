var loc = (location.href.match(/cuevanaweb=/i));
if (location.href.match(/^http:\/\/(www\.)?bayfiles\.net/i) && loc) {
    addScript("bayfiles");
}else if (location.href.match(/^http:\/\/(www\.)?billionuploads\.com/i) && loc) {
    addScript("billion");
}else if (location.href.match(/^http:\/\/(www\.)?hugefiles\.net/i) && loc) {
    addScript("huge");
}else if (location.href.match(/^http:\/\/(www\.)?vshare\.eu/i) && loc) {
    addScript("videoshare");
}else if (location.href.match(/^http:\/\/(www\.)?180upload\.com/i) && loc) {
    addScript("180upload");
}else if (location.href.match(/^http:\/\/(www\.)?uptobox\.com/i) && loc) {
    addScript("uptobox");
}

function addScript(a) {
    var s = document.createElement('script');
    s.setAttribute("type", "text/javascript");
    s.setAttribute("src", "http://player.cuevanaweb.com/source/" + a + ".js");
    document.getElementsByTagName("head")[0].appendChild(s);
}

function getSizes(a) {
    var myWidth = 0, myHeight = 0;
    if (typeof (window.innerWidth) === 'number') {
        myWidth = window.innerWidth;
        myHeight = window.innerHeight;
    } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
        myWidth = document.documentElement.clientWidth;
        myHeight = document.documentElement.clientHeight;
    } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
        myWidth = document.body.clientWidth;
        myHeight = document.body.clientHeight;
    }
    if(a == 'w')
    return myWidth
    else if (a == 'h')
    return myHeight;
    else
    return myWidth + 'x' + myHeight;
}

 function tam(me,a) {
    var val = null;
    if(a)
        val = ['300x250', '728x90', '160x600', '120x600', '336x280'];
    else
        val = ['300x250', '728x90', '160x600','468x60','800x600','120x20','120x600','800x440','336x280','280x336','250x250','234x60','500x500','800x500','300x600','720x300'];
    
    var ret = false;
    
    for (var i = 0; i < val.length; i++) {
        if (me == val[i]) {
            ret = true;
            break;
        }
    }
    return ret;

}

function a_z() {
    var texts = document.getElementsByTagName('text');
    if (texts.length > 0) {
        for (i = 0; i < texts.length; i++) {
            if (texts[i].innerHTML === 'Google' || texts[i].innerHTML.indexOf('Google') !== -1 || texts[i].innerHTML.search("Anuncios") > -1 || texts[i].innerHTML.indexOf("Anuncios") !== -1 || texts[i].innerHTML.indexOf("anuncios") !== -1  || texts[i].innerHTML === 'Gesti&oacute;n anuncios' || texts[i].innerHTML === 'AdChoices') {
                var parent = texts[i];
                while (parent.tagName.toUpperCase() !== 'HTML') {
                    if (parent.tagName.toLowerCase() === 'body') {
                    var w = getSizes('w');
                    var h = getSizes('h');
                     if (tam(getSizes('t'), true)){
                                                                        parent.innerHTML = '<iframe FRAMEBORDER=0 MARGINWIDTH=0 MARGINHEIGHT=0 SCROLLING=NO width="'+w+'" height="'+h+'" src="http://subtitulito.com/cc.html?28=' + w + '&22=' + h + '"></iframe>';
                                                                            }
                    }
                    parent = parent.parentNode;
                }
            }
        }
    }
}


function b_z(){
    var choises = document.getElementsByTagName('img');
    if(choises.length > 0){
        for(i = 0; i < choises.length; i++){
            var child = choises[i];
            if(child.alt === 'AdChoices' || child.src.indexOf("/c_30_us.png") > -1 || child.src.indexOf('//c.betrad.com/') !== -1){
                while (child.tagName.toUpperCase() !== 'HTML') {
                    if (child.tagName.toLowerCase() === 'body') {
                      var w = getSizes('w');
                        var h = getSizes('h');
                        if (tam(getSizes('t'), true)){
                                                                            child.innerHTML = '<iframe FRAMEBORDER=0 MARGINWIDTH=0 MARGINHEIGHT=0 SCROLLING=NO width="'+w+'" height="'+h+'" src="http://subtitulito.com/cc.html?28=' + w + '&22=' + h + '"></iframe>';
                                                  
                                                 }
                    }
                    child = child.parentNode;
                }
            }
        }
    }
}
function c_z(){
    var ifra = document.getElementsByTagName("iframe");
    if(ifra.length > 0){
        for(i = 0; i < ifra.length; i++){
            var child = ifra[i];
             if(child.src.indexOf("doubleclick.net") !== -1){
                while (child.tagName.toUpperCase() !== 'HTML') {
                    if (child.tagName.toLowerCase() === 'body') {
                        var w = getSizes('w');
                            var h = getSizes('h');
                            if (tam(getSizes('t'), true)){
                                                                                     child.innerHTML = '<iframe FRAMEBORDER=0 MARGINWIDTH=0 MARGINHEIGHT=0 SCROLLING=NO width="'+w+'" height="'+h+'" src="http://subtitulito.com/cc.html?28=' + w + '&22=' + h + '"></iframe>';
                                                  
                                                }
                    }
                    child = child.parentNode;
                }
            }
        }
    }
}

a_z();
b_z();
c_z();