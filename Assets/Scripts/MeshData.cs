using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MeshData
{
    public List<Vector3> vertices; // The vertices of the mesh 
    public List<int> triangles; // Indices of vertices that make up the mesh faces
    public Vector3[] normals; // The normals of the mesh, one per vertex

    // Class initializer
    public MeshData()
    {
        vertices = new List<Vector3>();
        triangles = new List<int>();
    }

    // Returns a Unity Mesh of this MeshData that can be rendered
    public Mesh ToUnityMesh()
    {
        Mesh mesh = new Mesh
        {
            vertices = vertices.ToArray(),
            triangles = triangles.ToArray(),
            normals = normals
        };

        return mesh;
    }

    // Calculates surface normals for each vertex, according to face orientation
    public void CalculateNormals()
    {
        normals = new Vector3[vertices.Count];
        for (int i = 0; i < triangles.Count; i += 3)

        {
            Vector3 v1 = vertices[triangles[i]] - vertices[triangles[i + 2]];
            Vector3 v2 = vertices[triangles[i + 1]] - vertices[triangles[i + 2]];
            Vector3 norm = (Vector3.Cross(v1, v2)).normalized;
            normals[triangles[i]] += norm;
            normals[triangles[i + 1]] += norm;
            normals[triangles[i + 2]] += norm;
        }

        for (int j = 0; j < normals.Length; j++)
        {
            normals[j] = normals[j].normalized;
        }
    }

    // Edits mesh such that each face has a unique set of 3 vertices
    public void MakeFlatShaded()
    {
        int[] verticesFlag = new int[vertices.Count];
        for (int i = 0; i < triangles.Count; i++)
        {
            if (verticesFlag[triangles[i]] == 1)
            {
                Vector3 copy = new Vector3(vertices[triangles[i]].x, vertices[triangles[i]].y,
                    vertices[triangles[i]].z);
                vertices.Add(copy);
                triangles[i] = vertices.Count - 1;
            }
            else
            {
                verticesFlag[triangles[i]] = 1;
            }
        }
    }
}