#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int clamp(int number, int min, int max, int from, int to)
{
	if (number < min) number = min;
	if (number > max) number = max;
	return round((((double)to - (double)from) / max) * number) + from;
}

extern "C" {
    __attribute__((visibility("default"))) __attribute__((used))
    const char *convert_to_ascii_string(char *bytes, int width, int height, int newWidth, int newHeight, char *density, bool isYUV, int flipCode, int *outLength)
    {
        Mat srcMat;
        if (isYUV)
        {
            Mat yuvMat(height * 1.5, width, CV_8UC1, bytes);
            cvtColor(yuvMat, srcMat, COLOR_YUV2RGB_NV21);
        }
        else
        {
            srcMat = Mat(height, width, CV_8UC3, bytes);
        }

        Mat dstMat;
        resize(srcMat, dstMat, Size(newHeight, newWidth), 0, 0, INTER_NEAREST);

        if (flipCode != 999)
        {
            flip(dstMat, dstMat, flipCode);
        }

        string asciiString = "";
        for (int x = 0; x < dstMat.cols; x++)
        {
            for (int y = dstMat.rows - 1; y >= 0; y--)
            {
                Vec3b& pixel = dstMat.at<Vec3b>(y, x);

                char r = pixel[0];
                char g = pixel[1];
                char b = pixel[2];

                char avg = (b + g + r) / 3;

                asciiString += density[clamp(avg, 0, 255, 0, strlen(density) - 1)];
            }
            asciiString += '\n';
        }

        *outLength = asciiString.length();

        return asciiString.c_str();
    }
}