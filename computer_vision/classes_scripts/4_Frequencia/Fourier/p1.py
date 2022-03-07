#!/usr/bin/python
import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('../images/sudoku.jpg',0)
#img = cv2.imread('../images/messi5_gray_blur_3x3.jpg',0)


print img.shape
f = np.fft.fft2(img)    #dothefouriertransform
fshift1 = np.fft.fftshift(f)    #shiftthezerotothecenter

#spectrumimage
magnitude_spectrum = 20 * np.log(np.abs(fshift1))

f_ishift = np.fft.ifftshift(fshift1)  #inverseshift
img_back = np.fft.ifft2(f_ishift) #inversefouriertransform
img_back = np.abs(img_back)

plt.subplot(121),plt.imshow(img,cmap='gray')
plt.title('Input Image'),plt.xticks([]),plt.yticks([])
plt.subplot(122),plt.imshow(magnitude_spectrum, cmap='gray')
plt.title('Magnitude Spectrum'), plt.xticks([]), plt.yticks([])
plt.show()
