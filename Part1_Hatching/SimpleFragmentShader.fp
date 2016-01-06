#version 330 core

// Values that stay constant for all fragments
uniform vec3 lightDirection; //direction of the light
// Texture sampler
uniform sampler2D myTextureSampler;

// Interpolated values from the vertex shaders
in vec3 fragmentNormal;
in vec3 viewDirection;
in vec2 textureuv;
in float distanceCamera;

in vec4 verticeposition;

// Output data
out vec3 color;
int specular_exp = 8;


void main()
{

    vec3 L = normalize(lightDirection);
	float bias = 0.10;

	vec2 tmp;	
      // normal is interpolated between all 3 surrounding vertices, it needs to be normalized before shading computation
      vec3 N = normalize(fragmentNormal);

      vec3 R = normalize(reflect((-L),N));
      vec3 V = normalize(viewDirection);

      // Diffuse shading
      float diffuse = min(1.0, max(dot(N,-L),0.));
	
	vec2 xy = vec2(textureuv.x/3., textureuv.y/3.);
	int x, y;

//Applying texture depending on the diffuse value
	if(diffuse < 0.33)
		x = 2; //third column of the texture
	else if(diffuse < 0.66)
		x = 1; //second column of the texture
	else
		x = 0; //first column of the texture
//Applying texture depending on the distance to camera
	if(distanceCamera-2 < 0.33 && distanceCamera-2 > 0)
		y = 0; //first row of the texture
	else if(distanceCamera-2 < 0.66 && distanceCamera-2 >= 0.33 )
		y = 1; //second row of the texture
	else
		y = 2; //third row of the texture

//Combining two values
	vec2 xy1 = vec2(xy.x+x/3., xy.y+y/3.);
	xy1 += vec2(xy.x+x/3., xy.y+y/3.-bias);

//Final color applied on the dragon
      color= texture(myTextureSampler, xy1).rgb;


}
