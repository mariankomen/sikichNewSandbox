public class CaseRecordController {

	@AuraEnabled
	public static Case getRecordDetail(String recId){
	return [SELECT CaseNumber, Subject, Comments, Description, External_Status__c FROM Case WHERE Id=:recId];
	}

	@AuraEnabled
	public static List<String> getAttachments(String recId){
		List<String> attachments = new List<String>();
		List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recId];
		system.debug(contentDocumentLinks);
		if (contentDocumentLinks .size() > 0)
		{
			List<Id> contentDocumentLinkIds = new List<Id>();
			for (ContentDocumentLink contentDocumentLink : contentDocumentLinks ) {
				contentDocumentLinkIds.add(contentDocumentLink .ContentDocumentId);
			}
			List<ContentVersion> contentVersions = [SELECT Id,ContentDocumentId,isLatest FROM ContentVersion WHERE ContentDocumentId in :contentDocumentLinkIds ];
			system.debug(contentVersions);
			if (contentVersions .size() > 0)
			{
				List<Id> contentVersionIds= new List<Id>();

				for (ContentVersion contentVersion : contentVersions )
					{
						contentVersionIds.add(contentVersion.ContentDocumentId);
					}
				List<ContentDocument> contentDocuments =[SELECT Id,Title,Description  FROM ContentDocument WHERE Id IN:contentVersionIds];
				system.debug(contentDocuments);
			for( ContentDocument doc: contentDocuments){
				attachments.add(doc.Title);
			}
			}}
return attachments;
	}

	@AuraEnabled(cacheable=true)
	public static List<CommentWrapper> getChatter(String recId){
	List<CaseFeed> item;
		try{
			 item = [Select Id, ParentId, Type, CreatedById, CreatedDate, IsDeleted, LastModifiedDate, SystemModstamp, CommentCount, LikeCount, Title, Body, LinkUrl, RelatedRecordId, InsertedById FROM CaseFeed WHERE ParentId =:recId];

		}
		catch (Exception ex){
			throw new AuraException(ex.getMessage());
		}


		system.debug('chatters'+item);
		List<Id> ids = new List<Id>();
		List<Id>feedsIds = new List<Id>();
		List<Id> idss= new List<Id>();
		for(CaseFeed f : item){
			ids.add(f.CreatedById);
			feedsIds.add(f.Id);
		}
		List<FeedComment> commentsList =[SELECT CommentBody,ParentId, FeedItemId, CreatedDate, CreatedById FROM FeedComment WHERE FeedItemId IN: feedsIds];

		system.debug(commentsList);
		for( FeedComment c: commentsList){
			idss.add(c.CreatedById);
		}
		List<User> users = [SELECT Name FROM  User WHERE Id IN: ids];
		system.debug('Users u'+users);
		List<CommentWrapper> comments = new List<CommentWrapper>();
		List<User>commentUsers = [SELECT Name FROM User WHERE Id IN: idss];

		for(Integer i=0; i<item.size();i++){
			if(item.get(i).Body!=null){
				List<CaseComentWrapper> wrappers = new List<CaseRecordController.CaseComentWrapper>();
				for(Integer j=0; j<commentsList.size(); j++){
					if(commentsList.get(j).FeedItemId==item.get(i).Id){
						for( User u : users){
							if(item.get(j).CreatedById == u.Id){
								String contentVerId ='';
								CaseComentWrapper caseComentWrapper = new CaseComentWrapper();
								system.debug('servlet'+commentsList.get(j).CommentBody);
								String imageURL='';
								String newURL;
								ContentVersion contentVersion;
								String image ='';
								Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher(item.get(i).Body);
								while (imgMatcher.find()) {
									String imageTag = imgMatcher.group();
									System.debug('imageTag^^'+imageTag );
									imageURL= imageTag.substringBetween(' src="', '"' );
									System.debug('imageURL^^' + imageURL );
									image = imageTag;
									system.debug('newURL'+newURL);
								}
								contentVerId =imageURL.remove('sfdc://');
								if(contentVerId!=''){
									try{
										contentVersion =[SELECT Id FROM ContentVersion WHERE ContentDocumentId=:contentVerId];
										newURL = image.replace(imageURL,'/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+contentVersion.Id);
										caseComentWrapper.commentBody = item.get(i).Body.replace(image,newURL);
									}
									catch (Exception ex){
										system.debug('no files found for chatter');
									}

								}
								else{
									caseComentWrapper.commentBody = item.get(i).Body;
								}

								system.debug(caseComentWrapper.commentBody);
									caseComentWrapper.Username= u.Name;
									caseComentWrapper.CreatedDate= commentsList.get(j).CreatedDate.format();
									wrappers.add(caseComentWrapper);



							}
						}

					}


				}
				for(User u: users){
					if(u.Id==item.get(i).CreatedById){
						CommentWrapper wrapper = new CommentWrapper();
						wrapper.Username = u.Name;
						wrapper.chatterId= item.get(i).Id;
						wrapper.comments = wrappers;
						String contentVerId ='';
						CaseComentWrapper caseComentWrapper = new CaseComentWrapper();
						String imageURL='';
						String newURL;
						ContentVersion contentVersion;
						String image ='';
						Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher(item.get(i).Body);
						while (imgMatcher.find()) {
							String imageTag = imgMatcher.group();
							System.debug('imageTag^^'+imageTag );
							imageURL= imageTag.substringBetween(' src="', '"' );
							System.debug('imageURL^^' + imageURL );
							image = imageTag;
						}
						contentVerId =imageURL.remove('sfdc://');
						system.debug('ContentVerID'+contentVerId);
						if(contentVerId!=''){
							contentVersion =[SELECT Id FROM ContentVersion WHERE ContentDocumentId=:contentVerId];
							newURL = image.replace(imageURL,'/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+contentVersion.Id);
							wrapper.commentBody = item.get(i).Body.replace(image,newURL);
							system.debug('wrapper.commentBody'+wrapper.commentBody);
						}
						else{
							wrapper.commentBody = item.get(i).Body;

						}
							wrapper.commentDate = item.get(i).CreatedDate.format();
							comments.add(wrapper);
							system.debug(wrapper);


					}

				}

			}
		}
		system.debug(System.JSON.serialize(comments));
		return comments;
	}

	@AuraEnabled
	public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId){

		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		if ( String.isBlank(fileId) ) {
			fileId = saveFiles(parentId, fileName, base64Data );
		} else {
			appendToFile(fileId, base64Data);
		}

		return Id.valueOf(fileId);
	}

	@AuraEnabled
	public static Id saveFiles(Id recordId, String fileName, String base64Data )  {
		ContentVersion contentToInsert =new ContentVersion();
		contentToInsert.Title =fileName;
		contentToInsert.VersionData=EncodingUtil.base64Decode(base64Data);
		contentToInsert.PathOnClient='/' + fileName ;
		contentToInsert.IsMajorVersion = false;
		insert contentToInsert;
		contentToInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: contentToInsert.Id];
		ContentDocumentLink cl = new ContentDocumentLink();
		cl.ContentDocumentId = contentToInsert.ContentDocumentId;
		cl.LinkedEntityId = recordId;
		cl.ShareType = 'V';
		cl.Visibility = 'AllUsers';
		insert cl;
		return contentToInsert.id;

	}


	@AuraEnabled
	public static void appendToFile(Id contentDocumentId, String base64Data) {
		ContentVersion versionData = [
				SELECT Id, VersionData,ContentDocumentId
				FROM ContentVersion
				WHERE Id = :contentDocumentId
		];

		String existingBody     = EncodingUtil.base64Encode(versionData.VersionData);
		versionData.VersionData = EncodingUtil.base64Decode(existingBody + base64Data);

		update versionData;
	}

public class CommentWrapper{
	 @AuraEnabled public String chatterId;
	@AuraEnabled public String Username;
	@AuraEnabled public String commentBody;
	@AuraEnabled public String commentDate;
	@AuraEnabled public List<CaseComentWrapper> comments;
}
	public class CaseComentWrapper{
		@AuraEnabled public String CommentBody;
		@AuraEnabled public String CreatedDate;
		@AuraEnabled public String Username;
	}
}