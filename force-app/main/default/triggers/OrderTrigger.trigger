trigger OrderTrigger on Order (before update) {

  if(Trigger.isBefore) {
    if(Trigger.isUpdate){
      OrderHandler.checkIfProductsOnOrders(trigger.new);
    }
  }

}