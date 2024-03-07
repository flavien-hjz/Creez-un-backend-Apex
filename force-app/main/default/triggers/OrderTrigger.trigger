trigger OrderTrigger on Order (before update, after insert, after delete) {

  if(Trigger.isBefore){
    if(Trigger.isUpdate){
      OrderHandler.updateOrderStatus(trigger.new);
    }
  }

  if(Trigger.isAfter){
    if(Trigger.isInsert){
      OrderHandler.makeAccountActive(trigger.new);
    }
    
    if(Trigger.isDelete){
      OrderHandler.makeAccountInactive(trigger.old);
    }
  }

}