using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


//using DiffMatchPatch;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.InteropServices;
using System.Web.Helpers;
using System.Net;
using System.IO;
using System.Diagnostics;

// mkaur24 12/14/2017  RMA-44257 Start
namespace DAGitHUb_Interface
{
    class Program : GitHUbBase
    {
        //  const string URL = "https://github.dxc.com/";
        static string urlParameters = "api/v3/repos/{repo}/contents/{contents}";
        static string ModulePath = "";
        bool flag = false;
        static bool FileErr = false;
        static void Main(string[] args)
        {
            try
            {
                GitHUbBase.ReadConfig();

                foreach (string item in DAModules)
                {
                    ModulePath = Basepath + "RISKMASTER_DataExchange\\" + FolderName + "\\" + item.Replace("/", "\\");
                    int i = item.LastIndexOf("/");
                    string itemValue = item;
                    int length = item.Length;
                    if (length == i + 1)
                        itemValue = item.Substring(0, i);
                    Message = "Download Started for : " + item.Replace("/", "->") + " at " + DateTime.Now + ".";
                    Console.WriteLine("Download Started for : " + item.Replace("/", "->") + " at " + DateTime.Now + ".");
                    if (!Directory.Exists(ModulePath))
                    {
                        Directory.CreateDirectory(ModulePath);
                    }
                    Program p = new Program();
                    p.GetContentsAsync(p.GetUrlParameter(urlParameters, "", FolderName + "/" + itemValue, RepoName), 0);
                    ///  Console.ReadKey();+
                }

                if (!FileErr)
                {
                    foreach (string item in DAModules)
                    {
                        if (item != "EDI/EDI SuppFields DbUpgrade" && item != "MEDICAL_EDI/MEDI SuppFields DbUpgrade" && item != "MBR/MBR SuppFields DBUpgrade")
                        {
                            int index = item.IndexOf("/");
                            string ModuleName = item.Substring(0, index);
                            if (ModuleNameList.Contains(ModuleName))
                                GitHUbBase.CopyFile(item);
                        }
                    }

                    GitHUbBase.ProcessInstaller("DELicenseKey");
                    GitHUbBase.ProcessInstaller("DAInstaller");
                    GitHUbBase.QADeliverable();
                }

                if ((!Error) && (!FileErr))
                {
                    Message = "GitHub File Download Completed at :" + DateTime.Now + ".";
                    Console.WriteLine("GitHub File Download Completed at :" + DateTime.Now + ".");
                    Message = "Thank you User!";
                    Console.WriteLine("Thank you User!");
                }
                else
                {
                    Message = "Errors Encountered while running GitHUb Installer.Please check DA Installer Logs.";
                    Console.WriteLine("Errors Encountered while running GitHUb Installer.Please check DA Installer Logs.");

                    Message = "Execution completed with errors at : " + DateTime.Now + ".";
                    Console.WriteLine("Execution completed with errors at : " + DateTime.Now + ".");

                    Message = "Please resolve the errors and re-run the GitHub Installer for successful completion.";
                    Console.WriteLine("Please resolve the errors and re-run the GitHub Installer for successful completion.");
                }

            }
            catch (System.Exception e)
            {
                Message = e.Message;
                Console.WriteLine(Message);
            }
            finally
            {
                GitHUbBase.WriteWarningFile();
            }
        }

        private string GetUrlParameter(string urlParameters, string Ref, string Path, string Repo)
        {
            return string.Format("{0}{1}", urlParameters, Ref).Replace("{repo}", Repo).Replace("{contents}", Path);
        }

        async void GetContentsAsync(string src, int fileorfolder)
        {
            try
            {
                Task<HttpResponseMessage> t1 = GetData(src);
                ///await Task.WhenAll(t1);
                HttpResponseMessage srcResponse = t1.Result;
                BindRTB(srcResponse, fileorfolder);
            }
            catch (System.Exception e)
            {
                Message = "Encountered error :" + "(" + e.Message + ")";
                Console.WriteLine(Message);
            }
        }

        void BindRTB(HttpResponseMessage response, int fileorfolder)
        {

            if (!response.IsSuccessStatusCode)
            {
                Message = "The GitHub Module Name/Path provided is invalid. Error :" + response.ReasonPhrase + ".";
                Console.WriteLine("The GitHub Module Name/Path provided is invalid. Error :" + response.ReasonPhrase + ".");
            }
            else
            {
                var dataObjects = response.Content.ReadAsStringAsync();
                dynamic srcData = Json.Decode(dataObjects.Result);

                if (fileorfolder == 0)
                {
                    foreach (var item in srcData)
                    {
                        string itemext = string.Empty;
                        int index = item.name.IndexOf(".");
                        if (index == -1)
                        { }
                        else
                        {
                            itemext = item.name.Substring(index);
                        }
                        if (!ExtList.Contains(itemext) || string.IsNullOrEmpty(itemext))
                        {
                            //do nothing
                        }
                        else
                        {
                            foreach (var item1 in ExcludeFiles)
                            {
                                if (item.name == item1)
                                {
                                    flag = true;
                                    Message = "Successful Message : File:" + item.name + " : has been successfully excluded.";
                                    Console.WriteLine("Successful Message : File:" + item.name + " : has been successfully excluded.");
                                    break;
                                }
                                else
                                {
                                    flag = false;
                                }
                            }

                            if (!flag)
                            {
                                try
                                {
                                    string Filepath = ModulePath + "\\" + item.name;
                                    using (var client = new System.Net.Http.HttpClient())
                                    {
                                        var credentials = string.Format(System.Globalization.CultureInfo.InvariantCulture, "{0}:", sToken);
                                        credentials = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(credentials));
                                        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Basic", credentials);
                                        var contents = client.GetByteArrayAsync(item.download_url).Result;
                                        System.IO.File.WriteAllBytes(Filepath, contents);
                                    }

                                    Message = "Successful Message : File:" + item.name + " : has been successfully downloaded.";
                                    Console.WriteLine("Successful Message : File:" + item.name + " : has been successfully downloaded.");
                                }
                                catch (System.Exception e)
                                {
                                    Message = "Error while getting the File:" + item.name + "(" + e.Message + ")";
                                    Console.WriteLine(Message);
                                    FileErr = true;
                                }

                            }
                            flag = false;
                        }
                    }
                }
                else
                {
                    //Do nothing; 
                }
            }
        }

        async Task<HttpResponseMessage> GetData(string urlParam)
        {
            HttpClient client = new HttpClient();
            client.BaseAddress = new Uri(URL);

            // Add an Accept header for JSON format.
            client.DefaultRequestHeaders.Accept.Add(
            new MediaTypeWithQualityHeaderValue("application/json"));

            client.DefaultRequestHeaders.Add("Authorization", "token " + sToken);
            HttpResponseMessage response = null;
            try
            {
                response = await client.GetAsync(urlParam);
            }
            catch (Exception ex)
            {
                Message = "Error while authentication :" + "(" + ex.Message + ")";
                Console.WriteLine(ex.Message);
            }

            return response;
        }
    }
    // mkaur24 12/14/2017  RMA-44257 End
}
