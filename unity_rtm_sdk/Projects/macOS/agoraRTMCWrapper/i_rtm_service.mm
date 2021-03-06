//
//  i_agora_rtm_service_c.cpp
//  agoraRTMCWrapper
//
//  Created by 张涛 on 2020/9/13.
//  Copyright © 2020 张涛. All rights reserved.
//

#include "i_rtm_service.h"
#include "RtmServiceEventHandler.h"
#include <vector>

extern "C" {
#define RTM_SERVICE_INSTANCE static_cast<agora::rtm::IRtmService *>(rtmInstance)
#define IMESSAGE_INSTANCE static_cast<agora::rtm::IMessage *>(message)
}

AGORA_API void* createRtmService_rtm()
{
    agora::rtm::internal::setRtmAppType(2);
    return agora::rtm::createRtmService();
}

AGORA_API const char* _getRtmSdkVersion_rtm()
{
    return agora::rtm::getRtmSdkVersion();
}

AGORA_API int setLogFileSize_rtm(void *rtmInstance, int fileSizeInKBytes)
{
    return RTM_SERVICE_INSTANCE->setLogFileSize(fileSizeInKBytes);
}

AGORA_API int setLogFilter_rtm(void *rtmInstance, int filter)
{
    return RTM_SERVICE_INSTANCE->setLogFilter(agora::rtm::LOG_FILTER_TYPE(filter));
}

AGORA_API int setLogFile_rtm(void *rtmInstance, const char* logfile)
{
    std::string filePath(logfile);
    filePath.append("_unity_plugin_log.txt");
    agora::unity::LogHelper::getInstance().startLogService(filePath.c_str());
    return RTM_SERVICE_INSTANCE->setLogFile(logfile);
}

AGORA_API int getChannelMemberCount_rtm(void *rtmInstance, const char* channelIds[], int channelCount, long long requestId)
{
    return RTM_SERVICE_INSTANCE->getChannelMemberCount(channelIds, channelCount, requestId);
}

AGORA_API int getChannelAttributesByKeys_rtm(void *rtmInstance, const char* channelId, const char* attributeKeys[], int numberOfKeys, long long requestId)
{
    return RTM_SERVICE_INSTANCE->getChannelAttributesByKeys(channelId, attributeKeys, numberOfKeys, requestId);
}

AGORA_API int getChannelAttributes_rtm(void *rtmInstance, const char* channelId, long long requestId)
{
    return RTM_SERVICE_INSTANCE->getChannelAttributes(channelId, requestId);
}


AGORA_API int clearChannelAttributes_rtm(void *rtmInstance, const char* channelId, bool enableNotificationToChannelMembers, long long requestId)
{
    agora::rtm::ChannelAttributeOptions option;
    option.enableNotificationToChannelMembers = enableNotificationToChannelMembers;
    return RTM_SERVICE_INSTANCE->clearChannelAttributes(channelId, option, requestId);
}

AGORA_API int deleteChannelAttributesByKeys_rtm(void *rtmInstance, const char* channelId, const char* attributeKeys[], int numberOfKeys, bool enableNotificationToChannelMembers, long long requestId)
{
    agora::rtm::ChannelAttributeOptions option;
    option.enableNotificationToChannelMembers = enableNotificationToChannelMembers;
    return RTM_SERVICE_INSTANCE->deleteChannelAttributesByKeys(channelId, attributeKeys, numberOfKeys, option, requestId);
}

AGORA_API int getUserAttributesByKeys_rtm(void *rtmInstance, const char* userId, const char* attributeKeys[], int numberOfKeys, long long requestId)
{
    return RTM_SERVICE_INSTANCE->getUserAttributesByKeys(userId, attributeKeys, numberOfKeys, requestId);
}

AGORA_API int getUserAttributes_rtm(void *rtmInstance, const char* userId, long long requestId)
{
    return RTM_SERVICE_INSTANCE->getUserAttributes(userId, requestId);
}

AGORA_API int clearLocalUserAttributes_rtm(void *rtmInstance, long long requestId)
{
    return RTM_SERVICE_INSTANCE->clearLocalUserAttributes(requestId);
}

AGORA_API int deleteLocalUserAttributesByKeys_rtm(void *rtmInstance, const char* attributeKeys[], int numberOfKeys, long long requestId)
{
    return RTM_SERVICE_INSTANCE->deleteLocalUserAttributesByKeys(attributeKeys, numberOfKeys, requestId);
}

AGORA_API int queryPeersOnlineStatus_rtm(void *rtmInstance, const char* peerIds[], int peerCount, long long requestId)
{
    return RTM_SERVICE_INSTANCE->queryPeersOnlineStatus(peerIds, peerCount, requestId);
}

AGORA_API int subscribePeersOnlineStatus_rtm(void *rtmInstance, const char* peerIds[], int peerCount, long long requestId)
{
    return RTM_SERVICE_INSTANCE->subscribePeersOnlineStatus(peerIds, peerCount, requestId);
}

AGORA_API int unsubscribePeersOnlineStatus_rtm(void *rtmInstance, const char* peerIds[], int peerCount, long long requestId)
{
    return RTM_SERVICE_INSTANCE->unsubscribePeersOnlineStatus(peerIds, peerCount, requestId);
}

AGORA_API int queryPeersBySubscriptionOption_rtm(void *rtmInstance,    agora::rtm::PEER_SUBSCRIPTION_OPTION option, long long requestId)
{
    return RTM_SERVICE_INSTANCE->queryPeersBySubscriptionOption(option, requestId);
}

AGORA_API int setLocalUserAttributes_rtm(void *rtmInstance, void* attributes, int numberOfAttributes, long long requestId)
{
    return RTM_SERVICE_INSTANCE->setLocalUserAttributes((agora::rtm::RtmAttribute *)attributes, numberOfAttributes, requestId);
}

AGORA_API int setChannelAttributes_rtm(void *rtmInstance, const char* channelId, long long attributes[], const int numberOfAttributes, bool enableNotificationToChannelMembers, long long requestId)
{
	if (numberOfAttributes <= 0)
		return -1;

    agora::rtm::ChannelAttributeOptions channelAttributeOptions;
    channelAttributeOptions.enableNotificationToChannelMembers = enableNotificationToChannelMembers;

	std::vector<const agora::rtm::IRtmChannelAttribute *> channelAttributeList;

	for(int i = 0; i < numberOfAttributes; i++) {
	    channelAttributeList.push_back(reinterpret_cast<agora::rtm::IRtmChannelAttribute *>(attributes[i]));
	}

    return RTM_SERVICE_INSTANCE->setChannelAttributes(channelId, &channelAttributeList[0], numberOfAttributes, channelAttributeOptions, requestId);
}

AGORA_API int addOrUpdateLocalUserAttributes_rtm(void *rtmInstance, void* attributes, int numberOfAttributes, long long requestId)
{
    return RTM_SERVICE_INSTANCE->addOrUpdateLocalUserAttributes((agora::rtm::RtmAttribute *)attributes, numberOfAttributes, requestId);
}

AGORA_API int setParameters_rtm(void *rtmInstance, const char* parameters)
{
    return RTM_SERVICE_INSTANCE->setParameters(parameters);
}

AGORA_API void *createChannelAttribute_rtm(void *rtmInstance)
{
    return RTM_SERVICE_INSTANCE->createChannelAttribute();
}

AGORA_API int createImageMessageByUploading_rtm(void *rtmInstance, const char* filePath, long long requestId)
{
    return RTM_SERVICE_INSTANCE->createImageMessageByUploading(filePath, requestId);
}

AGORA_API int createFileMessageByUploading_rtm(void *rtmInstance, const char* filePath, long long requestId)
{
    return RTM_SERVICE_INSTANCE->createFileMessageByUploading(filePath, requestId);
}

AGORA_API void *createImageMessageByMediaId_rtm(void *rtmInstance, const char* mediaId)
{
    return RTM_SERVICE_INSTANCE->createImageMessageByMediaId(mediaId);
}

AGORA_API void *createFileMessageByMediaId_rtm(void *rtmInstance, const char* mediaId)
{
    return RTM_SERVICE_INSTANCE->createFileMessageByMediaId(mediaId);
}

AGORA_API void *createMessage_rtm(void *rtmInstance, const uint8_t* rawData, int length, const char* description)
{
    return RTM_SERVICE_INSTANCE->createMessage(rawData, length, description);
}

AGORA_API void *createMessage2_rtm(void *rtmInstance, const uint8_t* rawData, int length)
{
    return RTM_SERVICE_INSTANCE->createMessage(rawData, length);
}

AGORA_API void *createMessage3_rtm(void *rtmInstance, const char* message)
{
    return RTM_SERVICE_INSTANCE->createMessage(message);
}

AGORA_API void *createMessage4_rtm(void *rtmInstance)
{
    return RTM_SERVICE_INSTANCE->createMessage();
}

AGORA_API void *createChannel_rtm(void *rtmInstance, const char *channelId, void *channelEventHandlerInstance)
{
    agora::unity::ChannelEventHandler *channelEventHandlerPtr= static_cast<agora::unity::ChannelEventHandler *>(channelEventHandlerInstance);
    return RTM_SERVICE_INSTANCE->createChannel(channelId, channelEventHandlerPtr);
}

AGORA_API int sendMessageToPeer_rtm(void *rtmInstance, const char *peerId, void *message, bool enableOfflineMessaging,
                                    bool enableHistoricalMessaging)
{
    agora::rtm::SendMessageOptions option;
    option.enableHistoricalMessaging = enableHistoricalMessaging;
    option.enableOfflineMessaging = enableOfflineMessaging;
    return RTM_SERVICE_INSTANCE->sendMessageToPeer(peerId, IMESSAGE_INSTANCE, option);
}

AGORA_API int cancelMediaUpload_rtm(void *rtmInstance, long long requestId)
{
    return RTM_SERVICE_INSTANCE->cancelMediaUpload(requestId);
}

AGORA_API int cancelMediaDownload_rtm(void *rtmInstance, long long requestId)
{
    return RTM_SERVICE_INSTANCE->cancelMediaDownload(requestId);
}

AGORA_API int downloadMediaToFile_rtm(void *rtmInstance, const char* mediaId, const char* filePath, long long requestId)
{
    return RTM_SERVICE_INSTANCE->downloadMediaToFile(mediaId, filePath, requestId);
}

AGORA_API int downloadMediaToMemory_rtm(void *rtmInstance, const char* mediaId, long long requestId)
{
    return RTM_SERVICE_INSTANCE->downloadMediaToMemory(mediaId, requestId);
}

AGORA_API int sendMessageToPeer2_rtm(void *rtmInstance, const char *peerId, void *message)
{
    return RTM_SERVICE_INSTANCE->sendMessageToPeer(peerId, IMESSAGE_INSTANCE);
}

AGORA_API int renewToken_rtm(void *rtmInstance, const char* token)
{
    return RTM_SERVICE_INSTANCE->renewToken(token);
}

AGORA_API int logout_rtm(void *rtmInstance)
{
    return RTM_SERVICE_INSTANCE->logout();
}

AGORA_API int login_rtm(void *rtmInstance, const char *token, const char *userId)
{
    return RTM_SERVICE_INSTANCE->login(token, userId);
}

AGORA_API void release_rtm(void *rtmInstance, bool sync)
{
    return RTM_SERVICE_INSTANCE->release(sync);
}

AGORA_API int initialize_rtm(void *rtmInstance, const char *appId, void *eventHandler)
{
    return RTM_SERVICE_INSTANCE->initialize(appId, static_cast<agora::unity::RtmServiceEventHandler *>(eventHandler));
}

AGORA_API void *getRtmCallManager_rtm(void *rtmInstance, void *rtmCallEventHandler)
{
    return RTM_SERVICE_INSTANCE->getRtmCallManager(static_cast<agora::unity::RtmCallEventHandler *>(rtmCallEventHandler));
}
