/**
 TestSTG4 Script Version 1
 */


function* bullet(id){
    for(var i=0;i<20;i++){
        yield;
    }

    setOmega(id,0.5)

    // for(var i=0;i<300;i++){
    //     yield;
    // }

    // deleteBullet(id);
}

function* gen(delta){
    var v=0
    while(true){
        for(var i=0;i<18;i++){
            v+=delta
            yield;
            for(var j=1;j<=3;j++){
                var id=createShot(j,getW()/2,getH()/2,j/2,v)
                runTask(bullet(id),id)
            }
        }
        // for(var i=0;i<36;i++){
        //     yield;
        // }
        // return;
    }
}

function* enemy(id){
    while(true){
        for(var i=0;i<60;i++){
            yield;
        }
        setRawSpeed(id,0,0)
        for(var i=Math.random()*12;i<=372;i+=30){
            createShot(2,getX(id),getY(id),2,i)
        }
        for(var i=0;i<60;i++){
            yield;
        }
        setRawSpeed(id,2,0)
    }
}

function* ene(){
    while(true){
        var id=createEnemy(0,-50,getH()/3*2,50,5,30)

        print(id)
        setRawSpeed(id,2,0)
        runTask(enemy(id),id)

        for(var i=0;i<120;i++){
            yield;
        }
    }
}

@init{
    
    runTask(ene())
    // runTask(gen(12))
    // runTask(gen(-12))
    // runTask(gen(25.534))
}

@update{
    // x.next(
}
