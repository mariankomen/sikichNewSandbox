trigger KnowledgeTrigger on Knowledge__kav (before update) {
    KnowledgeTriggerHandler handler = new KnowledgeTriggerHandler(Trigger.new);

}