import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('classes_scripts/3_Realce/images/sudoku.jpg')
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(gray,50,150,apertureSize = 3)
minLineLength = 0
maxLineGap = 0

cv2.imshow("Original", edges)
cv2.waitKey(0)

#lines = cv2.HoughLinesP(edges,1,np.pi/180,200) #,minLineLength,maxLineGap)
#for x1,y1,x2,y2 in lines[0]:
#    cv2.line(img,(x1,y1),(x2,y2),(0,255,0),2)

#plt.subplot(131),plt.imshow(img,cmap='gray')
#plt.title('Input Image'),plt.xticks([]),plt.yticks([])
#plt.subplot(132),plt.imshow(edges, cmap='gray')
#plt.title('Canny'), plt.xticks([]), plt.yticks([])
#plt.subplot(133),plt.imshow(img, cmap='gray')
#plt.title('Output'), plt.xticks([]), plt.yticks([])
#plt.show()

#cv2.imwrite('houghlines5.jpg',img)
