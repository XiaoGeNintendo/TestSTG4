/*
 Global js
 */

var eventPool=[]
var empty=[]

function runTask(task){
    if(empty.length==0){
        eventPool.push(task)

        return eventPool.length-1
    }else{
        var last=empty.pop()
        eventPool[last]=task

        return last
    }
}

function poolUpdate(){
    for(var i=0;i<eventPool.length;i++){
        var task=eventPool[i]
        if(task==null){
            continue;
        }
        var ret=task.next()

        if(ret.done){
            task=null
            empty.push(i)
        }
    }
}
