Shader "Custom/Shadows"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 100

        Pass
        {
            // Prevent backface culling with Cull Off.
            Cull Off
            // Don't disable any objects behind the material, because those background objects may not be fully occluded.
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Defines the data for each vertex.
            struct WriteVertex
            {
                float3 position;
            };
            // Defines the data for each triangle.
            struct WriteTriangle
            {
                WriteVertex vertices[3];
                float3 normal;
            };
            StructuredBuffer<WriteTriangle> _WriteTriangles;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (uint vertexID : SV_VertexID)
            {
                v2f output;

                // Get the index of the first vertex in the triangle.
                WriteTriangle writeTriangle = _WriteTriangles[vertexID / 3];
                // Get the specific index of that vertex.
                WriteVertex input = writeTriangle.vertices[vertexID % 3];

                // Transform the vertex from world space to clip space.
                output.vertex = UnityObjectToClipPos(float4(input.position, 1));
                // Define the triangle normal.
                output.normal = writeTriangle.normal;

                return output;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Define the triangle color.
                fixed4 col = fixed4(0, 0, 0, 1);
                return col;
            }
            ENDCG
        }
    }
}