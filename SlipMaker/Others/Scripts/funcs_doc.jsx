﻿// ルーラーを原点にfunction rurerOrigin(){    try{        var ab  = app.activeDocument.artboards[0];        ab.rulerOrigin = [0, 0];    }catch(e){        //alert(e.message, "アートボード警告", true);    }}