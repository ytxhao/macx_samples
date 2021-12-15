#import "mac_recoder.h"
#include <iostream>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#include <ApplicationServices/ApplicationServices.h>
#include <libkern/OSAtomic.h>  // OSAtomicCompareAndSwap()
#include <mach/mach.h>         // mach_task_self()
#include <sys/sysctl.h>        // sysctlbyname()
#include "checks.h"
#include "logging.h"

#include <memory>

MacRecoder::MacRecoder(int sample_rate, const std::string& bgm_file_url, const std::string& file_url):
    _inputDeviceIndex(0),
    _outputDeviceIndex(0),
    _inputDeviceID(kAudioObjectUnknown),
    _outputDeviceID(kAudioObjectUnknown),
    _inputDeviceIsSpecified(false),
    _outputDeviceIsSpecified(false),
    _recChannels(N_REC_CHANNELS),
    _playChannels(N_PLAY_CHANNELS),
    _captureBufData(NULL),
    _renderBufData(NULL),
    _initialized(false),
    _isShutDown(false),
    _recording(false),
    _playing(false),
    _recIsInitialized(false),
    _playIsInitialized(false),
    _renderDeviceIsAlive(1),
    _captureDeviceIsAlive(1),
    _twoDevices(true),
    _doStop(false),
    _doStopRec(false),
    _macBookPro(false),
    _macBookProPanRight(false),
    _captureLatencyUs(0),
    _renderLatencyUs(0),
    _captureDelayUs(0),
    _renderDelayUs(0),
    _renderDelayOffsetSamples(0),
    _paCaptureBuffer(NULL),
    _paRenderBuffer(NULL),
    _captureBufSizeSamples(0),
    _renderBufSizeSamples(0),
    prev_key_state_()
{
    this->sample_rate_ = sample_rate;
    this->bgm_file_url_ = bgm_file_url;
    this->file_url_ = file_url;
//    NSString * nss_bgm_file_url = [NSString stringWithCString:bgm_file_url.c_str() encoding:NSUTF8StringEncoding];
//    NSString * nss_file_url = [NSString stringWithCString:file_url.c_str() encoding:NSUTF8StringEncoding];

    memset(_renderConvertData, 0, sizeof(_renderConvertData));
    memset(&_outStreamFormat, 0, sizeof(AudioStreamBasicDescription));
    memset(&_outDesiredFormat, 0, sizeof(AudioStreamBasicDescription));
    memset(&_inStreamFormat, 0, sizeof(AudioStreamBasicDescription));
    memset(&_inDesiredFormat, 0, sizeof(AudioStreamBasicDescription));
    std::cout << "Base::~Base11111" << std::endl;
    

}

MacRecoder::~MacRecoder() {
    RTC_DLOG(LS_INFO) << __FUNCTION__ << " destroyed";

    if (!_isShutDown) {
//      Terminate();
    }

    RTC_DCHECK(capture_worker_thread_.empty());
    RTC_DCHECK(render_worker_thread_.empty());

    if (_paRenderBuffer) {
      delete _paRenderBuffer;
      _paRenderBuffer = NULL;
    }

    if (_paCaptureBuffer) {
      delete _paCaptureBuffer;
      _paCaptureBuffer = NULL;
    }

    if (_renderBufData) {
      delete[] _renderBufData;
      _renderBufData = NULL;
    }

    if (_captureBufData) {
      delete[] _captureBufData;
      _captureBufData = NULL;
    }

    kern_return_t kernErr = KERN_SUCCESS;
    kernErr = semaphore_destroy(mach_task_self(), _renderSemaphore);
    if (kernErr != KERN_SUCCESS) {
      RTC_LOG(LS_ERROR) << "semaphore_destroy() error: " << kernErr;
    }

    kernErr = semaphore_destroy(mach_task_self(), _captureSemaphore);
    if (kernErr != KERN_SUCCESS) {
//      RTC_LOG(LS_ERROR) << "semaphore_destroy() error: " << kernErr;
    }
}

//
//int32_t AudioDeviceMac::Terminate() {
//  if (!_initialized) {
//    return 0;
//  }
//
//  if (_recording) {
//    RTC_LOG(LS_ERROR) << "Recording must be stopped";
//    return -1;
//  }
//
//  if (_playing) {
//    RTC_LOG(LS_ERROR) << "Playback must be stopped";
//    return -1;
//  }
//
//  MutexLock lock(&mutex_);
//  _mixerManager.Close();
//
//  OSStatus err = noErr;
//  int retVal = 0;
//
//  AudioObjectPropertyAddress propertyAddress = {
//      kAudioHardwarePropertyDevices, kAudioObjectPropertyScopeGlobal,
//      kAudioObjectPropertyElementMaster};
//  WEBRTC_CA_LOG_WARN(AudioObjectRemovePropertyListener(
//      kAudioObjectSystemObject, &propertyAddress, &objectListenerProc, this));
//
//  err = AudioHardwareUnload();
//  if (err != noErr) {
//    logCAMsg(rtc::LS_ERROR, "Error in AudioHardwareUnload()",
//             (const char*)&err);
//    retVal = -1;
//  }
//
//  _isShutDown = true;
//  _initialized = false;
//  _outputDeviceIsSpecified = false;
//  _inputDeviceIsSpecified = false;
//
//  return retVal;
//}


MacRecoder::InitStatus MacRecoder::Init() {
    std::lock_guard<std::mutex> guard(mutex_);
    if (_initialized) {
      return InitStatus::OK;
    }
    
    OSStatus err = noErr;
    _isShutDown = false;
    
    // PortAudio ring buffers require an elementCount which is a power of two.
     if (_renderBufData == NULL) {
       UInt32 powerOfTwo = 1;
       while (powerOfTwo < PLAY_BUF_SIZE_IN_SAMPLES) {
         powerOfTwo <<= 1;
       }
       _renderBufSizeSamples = powerOfTwo;
       _renderBufData = new SInt16[_renderBufSizeSamples];
     }

    return InitStatus::OK;
}

void MacRecoder::StartRecording() {

}

void MacRecoder::StopRecording() {

}


int MacRecoder::InitRecoder(int sample_rate,const std::string& fileURL, const std::string& bgmFileURL) {
    return 0;
}


