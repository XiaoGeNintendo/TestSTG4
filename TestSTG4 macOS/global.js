/*
 Global js
 */

var eventPool=[]
var empty=[]
var master=[]

function runTask(task,asso){

    asso = asso ?? -1
    if(empty.length==0){
        eventPool.push(task)
        master.push(asso)

        return eventPool.length-1
    }else{
        var last=empty.pop()

        eventPool[last]=task
        master[last]=asso
        return last
    }
}

function poolUpdate(){
    for(var i=0;i<eventPool.length;i++){
        var task=eventPool[i]
        if(task==null){
            continue;
        }

        // if(master[i]!=-1){
        //     print(master[i]+" "+isAlive(master[i]))
        // }
        if(master[i]!=-1 && !isAlive(master[i])){
            // print("Terminated for "+master[i])
            eventPool[i]=null
            empty.push(i)
            continue;
        }

        var ret=task.next()

        if(ret.done){
            eventPool[i]=null
            empty.push(i)
        }
    }

    print("Fini")
}
