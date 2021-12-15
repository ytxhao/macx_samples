#ifndef MAC_RECODER_H
#define MAC_RECODER_H
#include <string>
#include <memory>
#include <mutex>
#include "event.h"
#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#include <mach/semaphore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#include "platform_thread.h"
#include "portaudio/pa_ringbuffer.h"

const uint32_t N_REC_SAMPLES_PER_SEC = 48000;
const uint32_t N_PLAY_SAMPLES_PER_SEC = 48000;

const uint32_t N_REC_CHANNELS = 1;   // default is mono recording
const uint32_t N_PLAY_CHANNELS = 2;  // default is stereo playout
const uint32_t N_DEVICE_CHANNELS = 64;

const int kBufferSizeMs = 10;

const uint32_t ENGINE_REC_BUF_SIZE_IN_SAMPLES =
    N_REC_SAMPLES_PER_SEC * kBufferSizeMs / 1000;
const uint32_t ENGINE_PLAY_BUF_SIZE_IN_SAMPLES =
    N_PLAY_SAMPLES_PER_SEC * kBufferSizeMs / 1000;

const int N_BLOCKS_IO = 2;
const int N_BUFFERS_IN = 2;   // Must be at least N_BLOCKS_IO.
const int N_BUFFERS_OUT = 3;  // Must be at least N_BLOCKS_IO.

const uint32_t TIMER_PERIOD_MS = 2 * 10 * N_BLOCKS_IO * 1000000;

const uint32_t REC_BUF_SIZE_IN_SAMPLES =
    ENGINE_REC_BUF_SIZE_IN_SAMPLES * N_DEVICE_CHANNELS * N_BUFFERS_IN;
const uint32_t PLAY_BUF_SIZE_IN_SAMPLES =
    ENGINE_PLAY_BUF_SIZE_IN_SAMPLES * N_PLAY_CHANNELS * N_BUFFERS_OUT;

const int kGetMicVolumeIntervalMs = 1000;

class MacRecoderInterface
{
public:
    virtual int InitRecoder(int sample_rate,const std::string& fileURL, const std::string& bgmFileURL) = 0;
    virtual ~MacRecoderInterface(){};

    virtual void StartRecording() = 0;
    virtual void StopRecording() = 0;

};

class MacRecoder : public MacRecoderInterface {
    
public:
    enum class InitStatus {
      OK = 0,
      PLAYOUT_ERROR = 1,
      RECORDING_ERROR = 2,
      OTHER_ERROR = 3,
      NUM_STATUSES = 4
    };
private:
    int sample_rate_;
    std::string bgm_file_url_;
    std::string file_url_;
    
    std::mutex mutex_;
    
//    AudioDeviceBuffer* _ptrAudioBuffer;
    
    rtc::Event _stopEventRec;
     rtc::Event _stopEvent;

     // Only valid/running between calls to StartRecording and StopRecording.
     rtc::PlatformThread capture_worker_thread_;

     // Only valid/running between calls to StartPlayout and StopPlayout.
     rtc::PlatformThread render_worker_thread_;

//     AudioMixerManagerMac _mixerManager;

     uint16_t _inputDeviceIndex;
     uint16_t _outputDeviceIndex;
     AudioDeviceID _inputDeviceID;
     AudioDeviceID _outputDeviceID;
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1050
     AudioDeviceIOProcID _inDeviceIOProcID;
     AudioDeviceIOProcID _deviceIOProcID;
   #endif
     bool _inputDeviceIsSpecified;
     bool _outputDeviceIsSpecified;

     uint8_t _recChannels;
     uint8_t _playChannels;

     Float32* _captureBufData;
     SInt16* _renderBufData;

     SInt16 _renderConvertData[PLAY_BUF_SIZE_IN_SAMPLES];

     bool _initialized;
     bool _isShutDown;
     bool _recording;
     bool _playing;
     bool _recIsInitialized;
     bool _playIsInitialized;

     // Atomically set varaibles
     int32_t _renderDeviceIsAlive;
     int32_t _captureDeviceIsAlive;

     bool _twoDevices;
     bool _doStop;  // For play if not shared device or play+rec if shared device
     bool _doStopRec;  // For rec if not shared device
     bool _macBookPro;
     bool _macBookProPanRight;

     AudioConverterRef _captureConverter;
     AudioConverterRef _renderConverter;

     AudioStreamBasicDescription _outStreamFormat;
     AudioStreamBasicDescription _outDesiredFormat;
     AudioStreamBasicDescription _inStreamFormat;
     AudioStreamBasicDescription _inDesiredFormat;

     uint32_t _captureLatencyUs;
     uint32_t _renderLatencyUs;

     // Atomically set variables
     mutable int32_t _captureDelayUs;
     mutable int32_t _renderDelayUs;

     int32_t _renderDelayOffsetSamples;

     PaUtilRingBuffer* _paCaptureBuffer;
     PaUtilRingBuffer* _paRenderBuffer;

     semaphore_t _renderSemaphore;
     semaphore_t _captureSemaphore;

     int _captureBufSizeSamples;
     int _renderBufSizeSamples;

     // Typing detection
     // 0x5c is key "9", after that comes function keys.
     bool prev_key_state_[0x5d];
public:
    MacRecoder(int sample_rate, const std::string& bgm_file_url, const std::string& file_url);
    ~MacRecoder() override;
    int InitRecoder(int sample_rate,const std::string& fileURL, const std::string& bgmFileURL) override;
    void StartRecording() override;
    void StopRecording() override;
    InitStatus Init();
    
};

#endif // AUDIO_UNIT_RECODER_H
