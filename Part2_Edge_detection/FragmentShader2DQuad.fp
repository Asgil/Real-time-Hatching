#version 330 core
//texture coordinates
in vec2 fragmentUV;
// texture
uniform sampler2D myTextureSampler;
// radius for edge detection
uniform int radius;
// rendered image width and height
uniform int renderwidth;
uniform int renderheight;


out vec3 color;

float intensity(in vec4 color1)
{
	return sqrt((color1.x*color1.x)+(color1.y*color1.y)+(color1.z*color1.z));
}

vec3 simple_edge_detection(in float step_x, in float step_y,in vec2 center)
{
	// Taking the central intensity for input texture
	float center_intensity = intensity(texture(myTextureSampler, center));

	int darker_count = 0;
	float max_intensity = center_intensity;
	//Looking at the pixel neighbours in the given radius
	for(int i = -radius; i <= radius; i++)
	{
		for(int j = -radius; j<= radius; j++)
		{
			vec2 current_location = center + vec2(i*step_x, j*step_y);
			float current_intensity = intensity(texture(myTextureSampler,current_location));
			if(current_intensity < center_intensity){
				darker_count++;
				}
			if(current_intensity > max_intensity) {
				max_intensity = current_intensity;
			}
		}
	}


	//Checking if we have a pixel on the edge
	if((max_intensity - center_intensity) > 0.01*radius)
	{
		if(darker_count/(radius*radius) < (1-(1/radius)))
		{
			//Black colour for pixels, which are on the edge
			return vec3(0.0,0.0,0.0); 
		}
	}
	//White colour for non-edge pixels
	return vec3(1.0,1.0,1.0);


}

void main()
{
	//Transforming width and height to [0;1] interval of the plane
	float step_x = 1.0/renderwidth;
	float step_y = 1.0/renderheight;
	//take the texture UV coordinates as a center pixel
	vec2 center_color = fragmentUV;
	color = simple_edge_detection(step_x, step_y, center_color);
}
