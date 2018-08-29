//
//  NBErrorCode.h
//  nebulaIosSdk
//
//  COPYRIGHT (C) 2014 NEC CORPORATION
//
//  ALL RIGHTS RESERVED BY NEC CORPORATION, THIS PROGRAM
//  MUST BE USED SOLELY FOR THE PURPOSE FOR WHICH IT WAS
//  FURNISHED BY NEC CORPORATION, NO PART OF THIS PROGRAM
//  MAY BE REPRODUCED OR DISCLOSED TO OTHERS, IN ANY FORM
//  WITHOUT THE PRIOR WRITTEN PERMISSION OF NEC CORPORATION.
//
//  NEC CONFIDENTIAL AND PROPRIETARY
//

#ifndef nebulaIosSdk_NBErrorCode_h
#define nebulaIosSdk_NBErrorCode_h

/**
 *  エラーコード一覧
 */
typedef NS_ENUM (NSInteger,NBErrorCode) {
    /**
     *  Precondition Error
     */
    NBErrorPreconditionError NS_SWIFT_NAME(preconditionError) = 1000,
    /**
     *  Invalid Argument Error
     */
    NBErrorInvalidArgumentError NS_SWIFT_NAME(invalidArgumentError),
    /**
     *  Request Error
     */
    NBErrorRequestError NS_SWIFT_NAME(requestError) = 1099,
    /**
     *  No information available.
     */
    NBErrorNoInfomation NS_SWIFT_NAME(noInformation) = 1100,
    /**
     *  Unsaved.
     */
    NBErrorUnsaved NS_SWIFT_NAME(unsaved),
    /**
     *  Unable to retrieve valid session token
     */
    NBErrorInvalidSessionToken NS_SWIFT_NAME(invalidSessionToken) = 1200,
    /**
     *  Failed to download
     */
    NBErrorFailedToDownload NS_SWIFT_NAME(failedToDownload)
};


#endif
