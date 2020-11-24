			$ModulePath = ""
			Write-Host "Publish to Powershell Gallery......" -NoNewline

			Try {
				Publish-Module -Path $ModulePath -NuGetApiKey $($env:psgallery_key) -SkipAutomaticTags -Confirm:$false -ErrorAction Stop -Force
				Write-Host "OK" -ForegroundColor Green
			}
			Catch {
				Write-Host "Failed - $_." -ForegroundColor Red
				throw $_
			}
			Finally {
				exit;
			}
