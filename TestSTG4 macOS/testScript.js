/**
 TestSTG4 Script Version 1
 */

function* gen(){
    var v=0
    while(true){
        for(var i=0;i<36;i++){
            v+=12
            yield;
            createShot(120,250,250,3,v)
        }
        for(var i=0;i<36;i++){
            yield;
        }
    }
}

var x=gen()
function onInit(scene){
    
}

function update(){
    x.next()
}
