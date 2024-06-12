uniform float uSize;
uniform vec2 uResolution;
attribute float aSize;
uniform float uProgress;
attribute float aTimeMultiplier;

#include ../includes/remap.glsl;

void main() {
    float progress=uProgress*aTimeMultiplier;

    vec3 newPosition = position; //as we cant change position it is an attribute

    //exploding
    float explodingProgress = remap(progress, 0.0, 0.1, 0.0, 1.0);
    explodingProgress = clamp(explodingProgress, 0.0, 1.0);
    explodingProgress = 1.0 - pow(1.0 - explodingProgress, 3.0);
    newPosition = mix(vec3(0.0),newPosition,explodingProgress);

    //falling
    float fallingProgress=remap(progress,0.1,1.0,0.0,1.0);
    fallingProgress=clamp(fallingProgress,0.0,1.0);
    fallingProgress=1.0-pow(1.0-fallingProgress,3.0);
    newPosition.y-=fallingProgress*0.2;

    //scaling
    float sizeOpeningProgress=remap(progress,0.0,0.125,0.0,1.0);
    float sizeClosingProgress=remap(progress,0.125,1.0,1.0,0.0);
    float sizeProgress=min(sizeOpeningProgress,sizeClosingProgress);
    sizeProgress=clamp(sizeProgress,0.0,1.0);


    //twinkling
    float twinklingProgress=remap(progress,0.2,0.8,0.0,1.0);
    twinklingProgress=clamp(twinklingProgress,0.0,1.0);
    float sizeTwinkling=sin(progress*30.0)*0.5+0.5;   //ranges form 0 to 1
    sizeTwinkling=1.0-sizeTwinkling*twinklingProgress;
    // final position
    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    gl_Position = projectionMatrix * viewPosition;

    // final size
    gl_PointSize = uSize * uResolution.y * aSize *sizeProgress*sizeTwinkling;  //fixing the 
    //weird behaviour of particles when the window is resized
    //only vertical resizing causes this glitch so 
    //making the size proportionate to the value of y(renderer's height) only
    gl_PointSize *= 1.0 / -viewPosition.z;

    if(gl_PointSize<1.0){
        gl_Position=vec4(9999.9); //moving the particles far away from the rendering clip space.
    }
    //to resolve windows issue(even though the particles are extremely small, they are still visible until they are completely removed from the scene)
}