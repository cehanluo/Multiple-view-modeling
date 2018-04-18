# Multiple-view modeling

### 1. Initial normal estimation
#### 1.1 Get data from the given path
Project description has already give the data link which contains some
images.
#### 1.2 Uniform resampling for light direction
(1) Build light direction sphere - build a standar icosahedron. Then,
perform subdivision on each face 4 times recursively. Use library "icosphere.m"
could produce this result and get the vertices coordinates. (This assume
the object is located at the center of the light direction sphere.)

(2) Get Li of each data set from its lightvec file - Li is the light vector of each image, represent in
(x,y,z). Normalize before use.


(3) Get Lo of each vertex by finding the nearest Li from the vertex - But there might be
some duplicate indices needed to be deleted. To be mentioned, the
coordinates of a vertex in the subdivision sphere could be used as the surface normal in
vertex surface. And the light direction Li is the vector point from surface to the light source.
(This could be found on lecture notes "light.ppt", p30-31.
Then, Lo = nearest(Li).

(4) Interpolate the image Io at Lo by

                                                          Lo * Li' * Ii(x,y)
           Io(x,y) = sum_{i | Li's NN == Lo} * -------------------------------------
                                                   sum_{i | Li's NN == Lo} Lo * Li'

This equation expressed in the Part 4.2 Uniform resampling of given paper "Dense Photometri Stereo Using a Mirror
Sphere and Graph Cut". In this project, Ii means ith image in the dataset and Li is the light vector
of the corresponding image. When processing, we would use all images, get resample image Io which is
a matrix with an adding dimension of image number index. Finally, resampled images and light vectors of them.

#### 1.3 Denominator image - automatic selection
(choose an image to cancel out the  surface albedo by producing ratio images)

(1) Stack the resampled images into a space-time volume - This process has been done in Section 1.2 (4)

(2) Get pixel intensities of each images in the space-time sequence - It is still in one matrix (x,y,img_num).

(3) Rank pixel intensities - for each pixel location (x,y), sort the corresponding pixel
intensities over time (the index of img_num). Then, the intensity rank at (x,y) is gotten.
Then, the intensity rank at (x,y) is greater than the median and smaller than the given
upper bound, it has a high probability to be free of shadows and highlight. In the paper,
the lower bound is 70% and the upper bound is 90% of whole image.
- kiL: total number of pixels in image(i) satisfiy 0.7 * num_img < rank(i) in image(i)
- riL: mean rank among the pixels in image(i) that satisfy rank < 0.7 * num_img.

Denominator img: the image with maximum kL and rL < 0.9 * num_img
Denominartor light: the light vector of denominator image.

#### 1.4 Initial normal estimation
(1) Get the light vectors exclude light vector of denominator image (Lrest).

(2) Get the image index exclude denominator image (Irest)

(3) Get the local initial normal by Single value decomposition (SVD) - last column of V matrix.
Remember to keep all normal in the same direction (reverse normal with negative z)

### 2. Normal refinement by MRF using graph cuts
#### 2.1 Create labels with z>0 on 5-times subdivided icosahedron
To increate precision, implement 5 times recursive subdivision of each face of an icosahedron.
Get the vertice information in the sphere. |L|=5057 --> filter out light vectors with z>0,
L is a discrete set of labels corresponding to different normal orientations.

#### 2.2 Construct graph
According to the given information in project description, use GCO 3.0 to construct graph.

#### 2.3 Minimize energy functions
Use GCO_expansion to calculate the min energy. Then use GCO_Getlabeling to get the label of segmentation result.

### 3. Build model
With refine normals of all pixels, reconstruct surface of all pixels.
Make use of function [shapeletsurf()][].


[shapeletsurf()]:http://www.peterkovesi.com/matlabfns/Shapelet/shapeletsurf.m "a"