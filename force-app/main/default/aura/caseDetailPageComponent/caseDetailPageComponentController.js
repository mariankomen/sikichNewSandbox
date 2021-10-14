({
    init : function(cmp, evt) {

        
        

        var action = cmp.get("c.getRecordDetail");
        action.setParams({
            "recId": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.case", response.getReturnValue());
                console.log('$$', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

        var chattersAction = cmp.get("c.getChatter");
        chattersAction.setParams({
            "recId": cmp.get("v.recordId")
        });
        chattersAction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.chatters", response.getReturnValue());
                console.log('%%', response.getReturnValue());

            }
        });
        $A.enqueueAction(chattersAction);


        var attachmentAction = cmp.get("c.getAttachments");
        attachmentAction.setParams({
            "recId": cmp.get("v.recordId")
        });
        attachmentAction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.attachments", response.getReturnValue());

            }
        });
        $A.enqueueAction(attachmentAction);

        setTimeout(function(){
            if(document.querySelector('button[aria-label="View More Posts"]')){
                document.querySelector('button[aria-label="View More Posts"]').click()
                console.log(1)
            }
            
         
        },1500)


        setTimeout(function(){
                let postItems = document.querySelectorAll("div.slds-feed__item")
                postItems.forEach(el => {
                // console.log(el.children[0].children[1].children[0].getAttribute('data-type'))
                if(el.children[0].children[1].children[0].getAttribute('data-type') !== 'TextPost'){
                    el.classList.add('classHider')
                    el.remove()
                }
            })
            console.log(2)

        },3000)

       
        
    
    },
    onRender: function (component, helper) {

        var deleteLinks = document.querySelectorAll('[src]');

            console.log('1.5sec')
            try{
                
                deleteLinks.forEach(el => {

                    el.addEventListener("click", function(){
                        window.open(el.getAttribute('src'))
                    });
                });
            } catch(e){
                console.log(e)
            }
    },

    

    clickHandler : function(cmp, event, helper) {

        var id = event.currentTarget.dataset.id;
        console.log(id);
        if(id=='openDiv'){
            $A.util.addClass(cmp.find('popup'), 'show'); 
            $A.util.addClass(cmp.find('backg'), 'show'); 
            cmp.set("v.popup", true);
            setTimeout(function(){
                document.querySelector('a[data-tab-name="FeedItem.TextPost"]').click()
                var btn = document.querySelector("div.bottomBarRight.slds-col--bump-left > button")

                

                setTimeout(function(){
                    btn.addEventListener('click', function(){
                        
                        // setTimeout(function(){
                        //     window.location.reload()
                        // },1000)
                    })
                    document.querySelector('a.cuf-visibilityMenu').click()
                    document.querySelector('a[title="All with access"]').click()
                    console.log('SDFSDFS:::::', document.querySelector('a[title="All with access"]').innerText)
                },500)

                
            },500)
            


        }
        else if(id=='closeDiv'){
            cmp.set("v.popup", false);
            
        }

        

    },


    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },

    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        var a = component.get('c.doSave');
        $A.enqueueAction(a);





    },
    closeWindow: function(cmp, event, helper){
        cmp.set("v.popup", false);
    },
    handlePostCreated: function(cmp,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Your comment has been uploaded successfully."
        });
        toastEvent.fire();
        cmp.set("v.popup", false);
        // setTimeout(function(){
        //     window.location.reload()
        // },1000)

    }
    


})