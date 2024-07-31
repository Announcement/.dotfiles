$KUBERNETES_RELEASE_URL="https://dl.k8s.io/release"
$KUBERNETES_SBOM_URL="https://sbom.k8s.io"

$KUBERNETES_STABLE=Invoke-RestMethod -Method Get -Uri "$KUBERNETES_RELEASE_URL/stable.txt"
Invoke-RestMethod -Method Get -Uri "$KUBERNETES_SBOM_URL/$KUBERNETES_STABLE/release" |
    bom document query 'name:(.*windows.*amd64.*)' | ForEach-Object {
        $temporaryFile = New-TemporaryFile
        $FILENAME = Split-Path $_ -Leaf
        Invoke-WebRequest -Uri "$KUBERNETES_RELEASE_URL/$KUBERNETES_STABLE/${_}.sig" -OutFile "${FILENAME}.sig"
        Invoke-WebRequest -Uri "$KUBERNETES_RELEASE_URL/$KUBERNETES_STABLE/${_}.cert" -OutFile "${FILENAME}.cert"
        Invoke-WebRequest -Uri "$KUBERNETES_RELEASE_URL/$KUBERNETES_STABLE/${_}" -OutFile "${temporaryFile}"
        if (Invoke-RestMethod -Uri $KUBERNETES_RELEASE_URL/$KUBERNETES_STABLE/${_}.sha256 -eq (Get-FileHash -Algorithm SHA256 $temporaryFile)) {
            Move-Item -Path $temporaryFile -Destination $FILENAME
        } else {
            Write-Error "$FILENAME FAILED TO DOWNLOAD! $temporaryFile"
        }
}
# Write-WebRequest "https://dl.k8s.io/release/$KUBECTL_RELEASE/bin/windows/amd64/kubectl.exe"
# Write-WebRequest "https://dl.k8s.io/$KUBECTL_RELEASE/bin/windows/amd64/kubectl.exe.sha256"
# Write-WebRequest "https://dl.k8s.io/release/$KUBECTL_RELEASE/bin/windows/amd64/kubectl-convert.exe"
# Write-WebRequest "https://dl.k8s.io/$KUBECTL_RELEASE/bin/windows/amd64/kubectl-convert.exe.sha256"
# Get-Content ~/kubernetes.spdx | bom document query 'name:(.*windows.*amd64.*)' | % { Write-WebRequest https://dl.k8s.io/release/$KUBECTL_RELEASE/$_.cert }