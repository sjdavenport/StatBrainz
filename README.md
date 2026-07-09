# StatBrainz
<table border="0">
  <tr>
    <td>
      <img src="https://github.com/sjdavenport/StatBrainz/blob/main/BrainImages/Other/logo.png" alt="Logo" width="1300" height="200">
    </td>
    <td>
      <p>
      The Statbrainz package contains Matlab code to perform statistical inference and visualization of brain imaging data. 
      This includes functions to perform resampling and multiple testing. In particular methods for clustersize inference 
      (including associated TDP bounds), and both single and simultaneous CoPE (coverage of probability sets) are provided. 
      The package also provides code for reading and visualizing volumetric and surface brain imaging data.
      </p>
    </td>
  </tr>
</table>

In order to install either download the zip file or run
```bash
git clone --depth=1 https://github.com/sjdavenport/StatBrainz/ 
```
from the command line.

In order to use the package, navigate to the StatBrainz main directory within matlab
and run the function addSB2path.m

## Requirements

StatBrainz runs in base MATLAB, but some functions require the following MATLAB toolboxes:

- **Statistics and Machine Learning Toolbox** — used throughout the inference and statistics code (e.g. `normcdf`, `norminv`, `tcdf`, `tinv`, `normrnd`, `binornd`, `randsample`, `prctile`, `corr`, `pdist`, `mvnpdf`, `skewness`, `kurtosis`).
- **Image Processing Toolbox** — used by `dilmask.m` (`imresize`, `strel`, `imdilate`, `imshow`).

SPM is no longer required.

## Illustrations
### Simultaneous bounds on excursion sets
![alt text](https://github.com/sjdavenport/StatBrainz/blob/main/BrainImages/Other/clustersizevsCIs2.png)

### Surface confidence sets
![alt text](https://github.com/sjdavenport/StatBrainz/blob/main/BrainImages/Other/surface_crs.png)

### Bounds on the true discovery proportion within a given cluster
![alt text](https://github.com/sjdavenport/StatBrainz/blob/main/BrainImages/Other/ctdp.png)
