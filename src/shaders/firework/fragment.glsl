uniform sampler2D uTexture;
uniform vec3 uColor;

void main() {
    float textureAlpha=texture(uTexture,gl_PointCoord).r;  //coz greyScale texture hai to ek hi channel chiye

    gl_FragColor = vec4(uColor,textureAlpha);
    // gl_FragColor = vec4(gl_PointCoord, 0.8, 1.0);
    // gl_FragColor = textureColor;
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}