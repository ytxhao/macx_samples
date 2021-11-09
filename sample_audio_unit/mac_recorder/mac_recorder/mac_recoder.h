#ifndef MAC_RECODER_H
#define MAC_RECODER_H
#include <string>
#import <Foundation/Foundation.h>
@class SGAudioEngine;

class MacRecoderInterface
{
public:
    virtual int InitRecoder(int sample_rate,const std::string& fileURL, const std::string& bgmFileURL) = 0;
    virtual ~MacRecoderInterface(){};

    virtual void startRecording() = 0;
    virtual void stopRecording() = 0;

};

class MacRecoder : public MacRecoderInterface {
private:
    __strong SGAudioEngine *_Nonnull audio_engine_;
    int sample_rate_;
    std::string bgm_file_url_;
    std::string file_url_;
public:
    MacRecoder(int sample_rate, const std::string& bgm_file_url, const std::string& file_url);
    ~MacRecoder() override;
    int InitRecoder(int sample_rate,const std::string& fileURL, const std::string& bgmFileURL) override;
    void startRecording() override;
    void stopRecording() override;
};

#endif // AUDIO_UNIT_RECODER_H
