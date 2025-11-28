<?php
// CRUD de serviços

// CREATE / UPDATE
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id       = $_POST['id_servico'] ?? '';
    $descricao= trim($_POST['descricao'] ?? '');
    $valor    = $_POST['valor'] !== '' ? (float)$_POST['valor'] : null;

    if ($descricao !== '' && $valor !== null) {
        if ($id) {
            $stmt = $pdo->prepare("UPDATE servicos
                                   SET descricao=?, valor=?
                                   WHERE id_servico=?");
            $stmt->execute([$descricao, $valor, $id]);
        } else {
            $stmt = $pdo->prepare("INSERT INTO servicos (descricao, valor)
                                   VALUES (?, ?)");
            $stmt->execute([$descricao, $valor]);
        }
    }
    header("Location: index.php?page=servicos");
    exit;
}

// DELETE
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $pdo->prepare("DELETE FROM servicos WHERE id_servico = ?")->execute([$id]);
    header("Location: index.php?page=servicos");
    exit;
}

// EDIT
$servEdicao = null;
if (isset($_GET['edit'])) {
    $id = (int)$_GET['edit'];
    $stmt = $pdo->prepare("SELECT * FROM servicos WHERE id_servico = ?");
    $stmt->execute([$id]);
    $servEdicao = $stmt->fetch();
}

// LISTA
$servicos = $pdo->query("SELECT * FROM servicos ORDER BY descricao")->fetchAll();
?>
<div class="section-header">
  <h2>Serviços</h2>
</div>

<div class="grid-2">
  <div class="card form-card">
    <h3><?php echo $servEdicao ? 'Editar Serviço' : 'Novo Serviço'; ?></h3>
    <form method="post">
      <input type="hidden" name="id_servico" value="<?php echo $servEdicao['id_servico'] ?? ''; ?>">
      <div class="form-group">
        <label>Descrição</label>
        <input type="text" name="descricao" required
               value="<?php echo htmlspecialchars($servEdicao['descricao'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Valor (R$)</label>
        <input type="number" step="0.01" min="0" name="valor" required
               value="<?php echo htmlspecialchars($servEdicao['valor'] ?? ''); ?>">
      </div>
      <button type="submit" class="btn primary">
        <?php echo $servEdicao ? 'Atualizar' : 'Salvar'; ?>
      </button>
      <?php if ($servEdicao): ?>
        <a href="index.php?page=servicos" class="btn secondary">Cancelar</a>
      <?php endif; ?>
    </form>
  </div>

  <div class="card">
    <h3>Lista de Serviços</h3>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Descrição</th>
            <th>Valor</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($servicos as $s): ?>
            <tr>
              <td><?php echo $s['id_servico']; ?></td>
              <td><?php echo htmlspecialchars($s['descricao']); ?></td>
              <td>R$ <?php echo number_format($s['valor'], 2, ',', '.'); ?></td>
              <td>
                <a class="btn secondary" href="index.php?page=servicos&edit=<?php echo $s['id_servico']; ?>">Editar</a>
                <a class="btn danger" href="index.php?page=servicos&delete=<?php echo $s['id_servico']; ?>"
                   onclick="return confirm('Deseja realmente excluir este serviço?');">
                  Excluir
                </a>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>
