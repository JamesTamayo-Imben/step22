<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>STEP security review required</title>
</head>
<body>
    <p>A project integrity issue was detected in STEP and requires review.</p>
    <p><strong>Project:</strong> {{ $projectTitle }}</p>
    <p><strong>Project ID:</strong> {{ $projectId }}</p>
    <p><strong>Affected blocks:</strong> {{ count($tamperedBlocks) }}</p>
    <p>Please review the blockchain integrity page. This email is an internal security alert; avoid taking action until the adviser completes the investigation.</p>
</body>
</html>