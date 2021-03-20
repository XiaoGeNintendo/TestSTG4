/**
 TestSTG4 Script Version 1
 */


function* bullet(id){
    for(var i=0;i<20;i++){
        yield;
    }

    setOmega(id,2)

    for(var i=0;i<80;i++){
        yield;
    }

    deleteBullet(id);
}

function* gen(delta){
    var v=0
    while(true){
        for(var i=0;i<18;i++){
            v+=delta
            yield;
            for(var j=1;j<=10;j++){
                var id=createShot(j,getW()/2,getH()/2,j/3,v)
                runTask(bullet(id))
            }
        }
        // for(var i=0;i<36;i++){
        //     yield;
        // }
        // return;
    }
}

@init{
    runTask(gen(12))
    runTask(gen(-12))
    // runTask(gen(25.534))
}

@update{
    // x.next(
}
