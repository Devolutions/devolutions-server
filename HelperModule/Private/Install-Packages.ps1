function Install-Packages {
    Install-IISFeatures
    if ((Test-dotNet)) {
        Install-Net472Core
    }
    Install-IisUrlRewrite

}