%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the unwrap function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MNImask = imgload('MNImask') > 0;
random_data = randn(size(MNImask));
random_data = fast_conv(random_data, 4, 3);
random_data_vec = random_data(MNImask);
unwrapped_data = unwrap(random_data_vec, MNImask);
subplot(2,1,1)
imagesc(random_data(:,:,50))
subplot(2,1,2)
imagesc(unwrapped_data(:,:,50))
